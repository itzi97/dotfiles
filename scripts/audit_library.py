#!/usr/bin/env python3
"""
audit_library.py — interactive Navidrome music metadata auditor.

Usage:
    audit-library [--dry-run] [~/Music/mp3]

Requires: eyeD3, requests  (pip install eyeD3 requests)
"""

import os
import re
import shutil
import argparse
import subprocess
import time
from pathlib import Path
from collections import Counter
from urllib.parse import quote_plus

AUDIO_EXT = {'.mp3', '.flac', '.m4a', '.aac', '.ogg', '.opus', '.wav', '.aiff', '.alac'}
IMG_EXT   = {'.jpg', '.jpeg', '.png', '.webp'}
MB_UA     = 'audit-library/1.0 ( https://github.com/itzi97/dotfiles )'


def c(text, code): return f'\033[{code}m{text}\033[0m'
def bold(t):   return c(t, '1')
def red(t):    return c(t, '31')
def green(t):  return c(t, '32')
def yellow(t): return c(t, '33')
def cyan(t):   return c(t, '36')
def dim(t):    return c(t, '2')


def run(cmd):
    return subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)


_INLINE_FIELDS = re.compile(
    r'(artist|album artist|album|title|release date|genre|track|disc):\s*([^\t]+)',
    re.IGNORECASE)


def _clean_genre(v):
    return re.sub(r'\s*\(id\s+\S+\)\s*$', '', v).strip()


def parse_tags(path):
    p = run(['eyeD3', '--no-color', str(path)])
    txt = p.stdout + '\n' + p.stderr
    data = {}
    for line in txt.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        for m in _INLINE_FIELDS.finditer(stripped):
            k = m.group(1).lower()
            v = re.sub(r'\s+', ' ', m.group(2).strip())
            if k == 'release date':
                hit = re.search(r'\b(\d{4})\b', v)
                v = hit.group(1) if hit else ''
                if not v:
                    continue
            if k == 'track':
                nums = re.findall(r'\d+', v)
                data['_tracknum']   = int(nums[0]) if nums else None
                data['_tracktotal'] = int(nums[1]) if len(nums) > 1 else None
                continue
            if k == 'genre':
                v = _clean_genre(v)
                if not v:
                    continue
            data.setdefault(k, v)
    data['_has_cover'] = 'FRONT_COVER Image:' in txt
    data['_file'] = str(path)
    return data


def unique_vals(tags, key):
    return sorted({t.get(key, '').strip() for t in tags if t.get(key, '').strip()})


def mb_search_release(query, limit=10):
    try:
        import requests
        q = query.replace(' ', '+').replace('"', '%22')
        r = requests.get(
            f'https://musicbrainz.org/ws/2/release/?query={q}&fmt=json&limit={limit}',
            headers={'User-Agent': MB_UA}, timeout=10)
        r.raise_for_status()
        return r.json().get('releases', [])
    except Exception as e:
        print(yellow(f'  MB search failed: {e}'))
        return []


def mb_cover_for_release(release_id):
    try:
        import requests
        r = requests.get(
            f'https://coverartarchive.org/release/{release_id}/front',
            headers={'User-Agent': MB_UA}, allow_redirects=True, timeout=15)
        if r.status_code == 200 and r.headers.get('content-type', '').startswith('image'):
            return r.content
    except Exception as e:
        print(yellow(f'  Cover fetch failed: {e}'))
    return None


def mb_cover_for_release_group(release_group_id):
    try:
        import requests
        r = requests.get(
            f'https://coverartarchive.org/release-group/{release_group_id}/front',
            headers={'User-Agent': MB_UA}, allow_redirects=True, timeout=15)
        if r.status_code == 200 and r.headers.get('content-type', '').startswith('image'):
            return r.content
    except Exception as e:
        print(yellow(f'  Release-group cover fetch failed: {e}'))
    return None


def mb_get_release_group_id(release_id):
    try:
        import requests
        time.sleep(1)
        r = requests.get(
            f'https://musicbrainz.org/ws/2/release/{release_id}?inc=release-groups&fmt=json',
            headers={'User-Agent': MB_UA}, timeout=10)
        r.raise_for_status()
        return r.json().get('release-group', {}).get('id')
    except Exception:
        return None


def fetch_mb_cover_with_fallback(release_id, release_title):
    print('  Trying release cover...')
    data = mb_cover_for_release(release_id)
    if data:
        return data, 'release'
    print(yellow('  No cover for this release. Trying release group...'))
    rgid = mb_get_release_group_id(release_id)
    if rgid:
        data = mb_cover_for_release_group(rgid)
        if data:
            return data, 'release group'
    return None, None


def discogs_search_url(artist, album):
    q = quote_plus(f'{artist} {album}'.strip())
    return f'https://www.discogs.com/search/?q={q}&type=release'


def download_url(url):
    try:
        import requests
        r = requests.get(url, headers={'User-Agent': MB_UA}, allow_redirects=True, timeout=20)
        r.raise_for_status()
        ct = r.headers.get('content-type', '')
        if 'image' in ct or url.lower().split('?')[0].endswith(('.jpg', '.jpeg', '.png', '.webp')):
            return r.content
        print(yellow(f'  URL did not return an image (content-type: {ct})'))
    except Exception as e:
        print(yellow(f'  URL download failed: {e}'))
    return None


def ask(prompt, default=''):
    hint = f' [{default}]' if default else ''
    try:
        ans = input(f'{prompt}{hint}: ').strip()
    except (EOFError, KeyboardInterrupt):
        print('')
        raise
    return ans if ans else default


def yesno(prompt, default='y'):
    hint = ' [Y/n]' if default == 'y' else ' [y/N]'
    ans = ask(prompt + hint, '').lower()
    if not ans:
        return default == 'y'
    return ans.startswith('y')


def choose(prompt, options, allow_skip=True):
    for i, o in enumerate(options, 1):
        print(f'  {dim(str(i))}. {o}')
    if allow_skip:
        print(f'  {dim("0")}. Skip')
    while True:
        ans = ask(prompt, '0' if allow_skip else '1')
        if ans.isdigit():
            n = int(ans)
            if allow_skip and n == 0:
                return None
            if 1 <= n <= len(options):
                return options[n - 1]
        print(yellow('  Invalid choice, try again.'))


def filename_title(path):
    stem = Path(path).stem
    return re.sub(r'^\d+\s*[-.\s]\s*', '', stem).strip()


def titles_look_generic(tags):
    bad = []
    for t in tags:
        title = t.get('title', '').strip()
        if not title or re.match(r'^[Tt]rack\s*\d+$', title):
            bad.append(t)
    return bad


def _show_releases(releases):
    for i, r in enumerate(releases, 1):
        artist = r.get('artist-credit', [{}])[0].get('artist', {}).get('name', '?')
        title  = r.get('title', '?')
        date   = str(r.get('date', '?'))[:4]
        print(f'    {dim(str(i))}. {artist} \u2014 {title} ({date})')
    print(f'    {dim("0")}. Try again / back')


def fix_duplicate_titles(tags, dup_titles, dry_run):
    """
    For each duplicated title, show the clashing files side-by-side and
    let the user rename a tag, delete a file, or skip.
    """
    for title in dup_titles:
        clashes = [t for t in tags
                   if t.get('title', '').strip().lower() == title.lower()]
        print(f'  {yellow(chr(8594))} Duplicate title: {bold(repr(title))}')
        for i, t in enumerate(clashes, 1):
            p    = Path(t['_file'])
            tnum = t.get('_tracknum')
            size = p.stat().st_size // 1024 if p.exists() else 0
            tnum_str = f'track {tnum}' if tnum else 'no track#'
            print(f'    {dim(str(i))}. {p.name}  {dim(f"[{tnum_str}, {size} KB]")}'
                  f'  title: {t.get("title", "")}')

        print(f'    {dim("r")}. Rename title tag on one of these files')
        print(f'    {dim("d")}. Delete one of these files')
        print(f'    {dim("s")}. Skip')

        while True:
            action = ask('  Action', 's').lower()

            if action == 's':
                break

            elif action == 'r':
                ans = ask(f'  Which file to rename (1-{len(clashes)})', '')
                if not ans.isdigit() or not (1 <= int(ans) <= len(clashes)):
                    print(yellow('  Invalid choice.'))
                    continue
                target = clashes[int(ans) - 1]
                new_title = ask('  New title', filename_title(target['_file']))
                if new_title:
                    if not dry_run:
                        run(['eyeD3', '-t', new_title, target['_file']])
                        print(green(f'    \u2713 Renamed title \u2192 "{new_title}"'))
                    else:
                        print(dim(f'    (dry-run) would rename title \u2192 "{new_title}"'))
                break

            elif action == 'd':
                ans = ask(f'  Which file to delete (1-{len(clashes)})', '')
                if not ans.isdigit() or not (1 <= int(ans) <= len(clashes)):
                    print(yellow('  Invalid choice.'))
                    continue
                target = Path(clashes[int(ans) - 1]['_file'])
                print(yellow(f'  About to delete: {target.name}'))
                if yesno('  Are you sure?', default='n'):
                    if not dry_run:
                        target.unlink()
                        print(green(f'    \u2713 Deleted {target.name}'))
                    else:
                        print(dim(f'    (dry-run) would delete {target.name}'))
                break

            else:
                print(yellow('  Type r, d, or s.'))


def find_cover_interactive(folder, audios, album_artists, artists, albums, dry_run):
    aa  = (album_artists + artists + [''])[0]
    alb = (albums + [''])[0]
    default_query = f'{aa} {alb}'.strip()
    cover_path = None

    while True:
        print(f'  {yellow(chr(8594))} Cover options:')
        print(f'  {dim("1")}. Search MusicBrainz')
        print(f'  {dim("2")}. Enter a URL')
        print(f'  {dim("3")}. Enter a local file path')
        print(f'  {dim("0")}. Skip')
        choice = ask('  Choice', '0')

        if choice == '0':
            break

        elif choice == '1':
            query = ask('  Search query', default_query)
            if not query:
                continue
            default_query = query
            releases = mb_search_release(query, limit=10)
            if not releases:
                print(yellow('  No results. Try a different query.'))
                continue
            _show_releases(releases)
            ans = ask('  Choose release (0 = back)', '0')
            if not ans.isdigit():
                continue
            idx = int(ans)
            if idx == 0:
                continue
            if not (1 <= idx <= len(releases)):
                continue
            chosen = releases[idx - 1]
            mbid   = chosen.get('id')
            data, source = fetch_mb_cover_with_fallback(mbid, chosen.get('title', ''))
            if data:
                print(green(f'  \u2713 Found cover via {source}'))
                cover_path = folder / 'cover.jpg'
                if not dry_run:
                    cover_path.write_bytes(data)
                    print(green(f'    Saved {cover_path}'))
                else:
                    print(dim(f'    (dry-run) would save {cover_path}'))
                    cover_path = None
                break
            else:
                discogs_url = discogs_search_url(aa, alb)
                print(yellow('  No cover found in Cover Art Archive (release or group).'))
                print(f'  {cyan(chr(8594))} Try finding it on Discogs:')
                print(f'    {bold(discogs_url)}')
                print(f'  Find the album, right-click the cover \u2192 Copy image address,')
                print(f'  then choose option 2 below to paste the URL.')
                if not yesno('  Try again?'):
                    break

        elif choice == '2':
            url = ask('  Image URL', '')
            if not url:
                continue
            print('  Downloading...')
            data = download_url(url)
            if data:
                ext = '.jpg'
                for candidate in ('.png', '.webp', '.jpeg'):
                    if url.lower().split('?')[0].endswith(candidate):
                        ext = candidate
                        break
                cover_path = folder / f'cover{ext}'
                if not dry_run:
                    cover_path.write_bytes(data)
                    print(green(f'    \u2713 Saved {cover_path}'))
                else:
                    print(dim(f'    (dry-run) would save {cover_path}'))
                    cover_path = None
                break
            else:
                if not yesno('  Try again?'):
                    break

        elif choice == '3':
            path_str = ask('  Local file path', '')
            if not path_str:
                continue
            src = Path(path_str).expanduser()
            if src.is_file():
                dst = folder / ('cover' + src.suffix)
                if not dry_run:
                    import shutil as _sh
                    _sh.copy2(str(src), str(dst))
                    cover_path = dst
                    print(green(f'    \u2713 Copied to {dst}'))
                else:
                    print(dim(f'    (dry-run) would copy to {dst}'))
                break
            else:
                print(yellow(f'  File not found: {src}'))

    return cover_path


def audit_folder(folder, root, dry_run):
    audios = sorted([p for p in folder.iterdir()
                     if p.is_file() and p.suffix.lower() in AUDIO_EXT])
    if not audios:
        return

    tags = [parse_tags(a) for a in audios]
    n = len(audios)

    artists       = unique_vals(tags, 'artist')
    album_artists = unique_vals(tags, 'album artist')
    albums        = unique_vals(tags, 'album')
    years         = unique_vals(tags, 'release date')
    genres        = unique_vals(tags, 'genre')
    folder_covers = [p for p in folder.iterdir()
                     if p.is_file() and p.suffix.lower() in IMG_EXT]
    embedded_covers = [t for t in tags if t['_has_cover']]

    issues = []

    if not folder_covers and not embedded_covers:
        issues.append('no_cover')
    elif embedded_covers and len(embedded_covers) < n:
        issues.append(('partial_cover', [t['_file'] for t in tags if not t['_has_cover']]))

    if not album_artists:
        issues.append('missing_album_artist')
    elif len(album_artists) > 1:
        issues.append(('mixed_album_artists', album_artists))

    if len(albums) > 1:
        issues.append(('mixed_albums', albums))

    if not years:
        issues.append('missing_year')
    elif len(years) > 1:
        issues.append(('mixed_years', years))

    if not genres:
        issues.append('missing_genre')

    missing_core = [t for t in tags
                    if not t.get('artist') or not t.get('album') or not t.get('title')]
    if missing_core:
        issues.append(('missing_core_tags', missing_core))

    generic_titles = titles_look_generic(tags)
    if generic_titles:
        issues.append(('generic_titles', generic_titles))

    tracknums = [t.get('_tracknum') for t in tags if t.get('_tracknum') is not None]
    if tracknums:
        counts = Counter(tracknums)
        dups = [num for num, cnt in counts.items() if cnt > 1]
        if dups:
            issues.append(('duplicate_tracknums', dups))
        gaps = sorted(set(range(1, max(tracknums) + 1)) - set(tracknums))
        if gaps:
            issues.append(('tracknum_gaps', gaps))

    totals = [t.get('_tracktotal') for t in tags if t.get('_tracktotal') is not None]
    if totals:
        stated = Counter(totals).most_common(1)[0][0]
        if stated != n:
            issues.append(('tracktotal_mismatch', f'tags say {stated}, folder has {n} files'))

    mismatches = []
    for t in tags:
        fn_t  = filename_title(t['_file']).lower()
        tag_t = t.get('title', '').strip().lower()
        if tag_t and not re.match(r'^track\s*\d+$', tag_t):
            fw = set(re.findall(r'\w+', fn_t))
            tw = set(re.findall(r'\w+', tag_t))
            if fw and tw:
                overlap = len(fw & tw) / max(len(fw), len(tw))
                if overlap < 0.5:
                    mismatches.append((Path(t['_file']).name, fn_t, tag_t))
    if mismatches:
        issues.append(('filename_tag_mismatch', mismatches))

    title_counts = Counter(t.get('title', '').strip().lower() for t in tags
                           if t.get('title', '').strip())
    dup_titles = [title for title, cnt in title_counts.items() if cnt > 1]
    if dup_titles:
        issues.append(('duplicate_titles', dup_titles))

    if not issues:
        return

    rel = str(folder.relative_to(root))
    print()
    print(bold(cyan(f'\u2500\u2500 {rel} \u2500\u2500')))
    print(dim(f'   {n} track(s)  artists: {artists}  '
              f'album_artists: {album_artists}  albums: {albums}  years: {years}'))
    for iss in issues:
        tag = iss if isinstance(iss, str) else iss[0]
        print(f'  {red(chr(10007))} {tag}')

    # ---- FIX: missing / mixed album artist ----
    if any(i == 'missing_album_artist' or
           (isinstance(i, tuple) and i[0] == 'mixed_album_artists') for i in issues):
        if len(artists) == 1:
            suggested = artists[0]
            print(f'  {yellow(chr(8594))} All tracks share one artist: {bold(suggested)}')
            if yesno(f'  Set album artist to "{suggested}" on all tracks?'):
                if not dry_run:
                    for a in audios:
                        run(['eyeD3', '--album-artist', suggested, str(a)])
                    print(green('    \u2713 Applied'))
                else:
                    print(dim(f'    (dry-run) would set album artist \u2192 "{suggested}"'))
        else:
            print(f'  {yellow(chr(8594))} Multiple track artists found:')
            suggested = choose('  Pick album artist (or 0 to type manually)',
                               artists + ['Various Artists'])
            if suggested is None:
                suggested = ask('  Type album artist manually', '')
            if suggested:
                if not dry_run:
                    for a in audios:
                        run(['eyeD3', '--album-artist', suggested, str(a)])
                    print(green('    \u2713 Applied'))
                else:
                    print(dim(f'    (dry-run) would set album artist \u2192 "{suggested}"'))

    # ---- FIX: mixed album names ----
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'mixed_albums':
            print(f'  {yellow(chr(8594))} Multiple album names: {iss[1]}')
            chosen = choose('  Pick correct album name (or 0 to type manually)', iss[1])
            if chosen is None:
                chosen = ask('  Type album name manually', '')
            if chosen:
                if not dry_run:
                    for a in audios:
                        run(['eyeD3', '--album', chosen, str(a)])
                    print(green('    \u2713 Applied'))
                else:
                    print(dim(f'    (dry-run) would set album \u2192 "{chosen}"'))

    # ---- FIX: missing year ----
    if 'missing_year' in issues:
        print(f'  {yellow(chr(8594))} No year tag found')
        yr = ask('  Enter year (leave blank to skip)', '')
        if yr and re.match(r'^\d{4}$', yr):
            if not dry_run:
                for a in audios:
                    run(['eyeD3', '-Y', yr, str(a)])
                print(green('    \u2713 Applied'))
            else:
                print(dim(f'    (dry-run) would set year \u2192 {yr}'))

    # ---- INFO: mixed years ----
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'mixed_years':
            print(f'  {yellow(chr(8594))} Mixed years in folder: {iss[1]} \u2014 check manually')

    # ---- FIX: missing genre ----
    if 'missing_genre' in issues:
        print(f'  {yellow(chr(8594))} No genre tag found')
        g = ask('  Enter genre (leave blank to skip)', '')
        if g:
            if not dry_run:
                for a in audios:
                    run(['eyeD3', '-G', g, str(a)])
                print(green('    \u2713 Applied'))
            else:
                print(dim(f'    (dry-run) would set genre \u2192 "{g}"'))

    # ---- FIX: missing core tags ----
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'missing_core_tags':
            bad = iss[1]
            print(f'  {yellow(chr(8594))} {len(bad)} track(s) missing artist/album/title')
            for t in bad:
                p = Path(t['_file'])
                print(f'    {dim(p.name)}')
                a  = ask('    artist',  t.get('artist',  artists[0] if artists else ''))
                al = ask('    album',   t.get('album',   albums[0]  if albums  else ''))
                ti = ask('    title',   t.get('title',   filename_title(str(p))))
                if not dry_run:
                    run(['eyeD3', '-a', a, '-A', al, '-t', ti, str(p)])
                    print(green('      \u2713 Applied'))
                else:
                    print(dim(f'      (dry-run) artist={a} album={al} title={ti}'))

    # ---- FIX: generic titles ----
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'generic_titles':
            bad = iss[1]
            print(f'  {yellow(chr(8594))} {len(bad)} track(s) have generic/blank titles')
            for t in bad:
                p = Path(t['_file'])
                print(f'    {dim(p.name)}')
                ti = ask('    title', filename_title(str(p)))
                if ti:
                    if not dry_run:
                        run(['eyeD3', '-t', ti, str(p)])
                        print(green('      \u2713 Applied'))
                    else:
                        print(dim(f'      (dry-run) title \u2192 "{ti}"'))

    # ---- INFO: track number issues ----
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'tracknum_gaps':
            print(f'  {yellow(chr(8594))} Missing track numbers in sequence: {iss[1]}')
            print(f'    Check if files are missing or track tags are wrong.')
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'duplicate_tracknums':
            print(f'  {yellow(chr(8594))} Duplicate track numbers: {iss[1]}')
            print(f'    Two files share the same track number \u2014 check manually.')
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'tracktotal_mismatch':
            print(f'  {yellow(chr(8594))} Track total mismatch: {iss[1]}')
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'filename_tag_mismatch':
            print(f'  {yellow(chr(8594))} Filename/title tag mismatch on {len(iss[1])} track(s):')
            for fname, fn_t, tag_t in iss[1]:
                print(f'    {dim(fname)}')
                print(f'      filename: {fn_t}')
                print(f'      tag:      {tag_t}')

    # ---- FIX: duplicate titles ----
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'duplicate_titles':
            fix_duplicate_titles(tags, iss[1], dry_run)

    # ---- FIX: no cover ----
    if 'no_cover' in issues:
        cover_path = find_cover_interactive(
            folder, audios, album_artists, artists, albums, dry_run)
        if cover_path and cover_path.exists():
            if yesno('  Embed cover into all tracks?'):
                if not dry_run:
                    for a in audios:
                        run(['eyeD3', '--add-image', f'{cover_path}:FRONT_COVER', str(a)])
                    print(green('    \u2713 Embedded in all tracks'))

    # ---- FIX: partial embedded cover ----
    for iss in issues:
        if isinstance(iss, tuple) and iss[0] == 'partial_cover':
            missing_files = iss[1]
            src_cover = folder_covers[0] if folder_covers else None
            if src_cover is None and embedded_covers:
                src_cover = Path(embedded_covers[0]['_file'])
            print(f'  {yellow(chr(8594))} Cover missing from {len(missing_files)} track(s)')
            if src_cover:
                name = src_cover.name if hasattr(src_cover, 'name') else str(src_cover)
                print(f'    Using cover from: {dim(name)}')
                if yesno('  Embed cover into tracks that are missing it?'):
                    if not dry_run:
                        for f in missing_files:
                            run(['eyeD3', '--add-image', f'{src_cover}:FRONT_COVER', f])
                        print(green('    \u2713 Embedded'))
                    else:
                        print(dim('    (dry-run) would embed cover into missing tracks'))
            else:
                print('    No cover source available \u2014 fix no_cover issue first.')


def main():
    ap = argparse.ArgumentParser(
        description='Interactive Navidrome music library metadata auditor')
    ap.add_argument('root', help='Root music folder (e.g. ~/Music/mp3)')
    ap.add_argument('--dry-run', action='store_true',
                    help='Show what would change without writing anything')
    args = ap.parse_args()

    root = Path(args.root).expanduser().resolve()
    if not root.is_dir():
        print(red(f'Not a directory: {root}'))
        return 1
    if not shutil.which('eyeD3'):
        print(red('eyeD3 not found \u2014 install with: python3 -m pip install eyeD3'))
        return 1
    try:
        import requests  # noqa
    except ImportError:
        print(yellow('requests not installed \u2014 cover art download disabled. '
                     'Run: python3 -m pip install requests'))

    print(bold(f'Auditing {root}'))
    if args.dry_run:
        print(yellow('  DRY RUN \u2014 no changes will be written'))

    folders_checked = 0
    for dirpath, dirnames, _ in os.walk(root):
        dirnames.sort()
        folder = Path(dirpath)
        if not folder.is_dir():
            continue
        audios = [p for p in folder.iterdir()
                  if p.is_file() and p.suffix.lower() in AUDIO_EXT]
        if not audios:
            continue
        folders_checked += 1
        try:
            audit_folder(folder, root, args.dry_run)
        except KeyboardInterrupt:
            print('\n' + yellow('Interrupted \u2014 exiting.'))
            break

    print(bold(green(f'\nDone. {folders_checked} album folder(s) checked.')))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
