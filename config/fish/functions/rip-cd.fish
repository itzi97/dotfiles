function clean_text
    string replace -a '_' ' ' -- $argv | string replace -r '\s+' ' ' | string trim
end

function mb_lookup_by_recording
    set -l rec   $argv[1]
    set -l art   $argv[2]
    set -l cntry $argv[3]
    set -l ua "rip-cd/1.0 ( https://github.com/itzi97/dotfiles )"
    set -l q "recording:\"$rec\""
    if test -n "$art"; set q "$q AND artist:\"$art\""; end
    set -l q_enc (string replace -a ' ' '+' -- "$q" | string replace -a '"' '%22' | string replace -a ':' '%3A')
    set -l country_part ""
    if test -n "$cntry"; set country_part "&country=$cntry"; end
    curl -s -A "$ua" "https://musicbrainz.org/ws/2/release/?query=$q_enc$country_part&fmt=json&limit=25"
end

function mb_lookup_release
    set -l query   $argv[1]
    set -l country $argv[2]
    set -l ua "rip-cd/1.0 ( https://github.com/itzi97/dotfiles )"
    set -l q_enc (string replace -a ' ' '+' -- "$query")
    set -l country_part ""
    if test -n "$country"; set country_part "&country=$country"; end
    curl -s -A "$ua" "https://musicbrainz.org/ws/2/release/?query=$q_enc$country_part&fmt=json&limit=25"
end

function mb_lookup_genre
    set -l rgid $argv[1]
    set -l ua "rip-cd/1.0 ( https://github.com/itzi97/dotfiles )"
    sleep 1
    set -l result (curl -s -A "$ua" "https://musicbrainz.org/ws/2/release-group/$rgid?inc=genres&fmt=json")
    echo $result | jq -r '.genres | sort_by(-.count) | .[0].name // empty'
end

function _show_releases
    set -l sorted_json $argv[1]
    set -l total       $argv[2]
    set -l mb_country  $argv[3]
    set -l sorted_count (echo $sorted_json | jq 'length')
    echo ""
    if test -n "$mb_country"
        echo "📚 Found $sorted_count release(s) — your CD has $total tracks (country hint: $mb_country):"
    else
        echo "📚 Found $sorted_count release(s) — your CD has $total tracks:"
    end
    echo ""
    for i in (seq 0 (math $sorted_count - 1))
        set -l r_artist  (echo $sorted_json | jq -r ".[$i][\"artist-credit\"][0].artist.name // \"Unknown\"")
        set -l r_title   (echo $sorted_json | jq -r ".[$i].title // \"Unknown\"")
        set -l r_date    (echo $sorted_json | jq -r ".[$i].date // \"?\"" | string match -r '^[0-9]{4}')
        set -l r_tracks  (echo $sorted_json | jq -r ".[$i][\"track-count\"] // \"?\"")
        set -l r_country (echo $sorted_json | jq -r ".[$i].country // \"?\"")
        set -l r_label   (echo $sorted_json | jq -r ".[$i][\"label-info\"][0].label.name // \"?\"")
        set -l num (math $i + 1)
        set -l marker ""
        if test "$r_tracks" = "$total"; set marker " ✨"; end
        if test -n "$mb_country" -a "$r_country" = "$mb_country"; set marker "$marker 🌍"; end
        printf "  [%d] %s — %s (%s) | %s tracks | %s | %s%s\n" $num "$r_artist" "$r_title" "$r_date" "$r_tracks" "$r_country" "$r_label" "$marker"
    end
    echo "  [0] None — enter metadata manually"
    echo ""
end

function _titles_are_generic
    for t in $argv
        if not string match -rq '^Track [0-9]+$' -- "$t"
            return 1
        end
    end
    return 0
end

# Read artist/album/year from eyeD3 tags using grep to preserve full multi-word values.
function _read_tags_from_file
    set -l file $argv[1]
    set -l out (eyeD3 --no-color "$file" 2>/dev/null)

    # grep -m1 'pattern' then strip everything up to and including the first ': '
    set -l albumartist (echo $out | grep -oP '(?<=album artist: )\S.*?(?=\s{2,}|$)' | head -1 | string trim)
    set -l artist      (echo $out | grep -oP '(?<=\bartist: )\S.*?(?=\s{2,}|$)'      | head -1 | string trim)
    set -l album       (echo $out | grep -oP '(?<=\balbum: )\S.*?(?=\s{2,}|$)'       | head -1 | string trim)
    set -l year        (echo $out | grep -oP '(?<=release date: )\d{4}'              | head -1)

    # album_artist (TPE2) takes priority
    if test -n "$albumartist"; set artist "$albumartist"; end

    echo "$artist"
    echo "$album"
    echo "$year"
end

# Detect if ALL files follow the VA pattern: NN - Artist - Title
function _files_are_va
    for f in $argv
        if not string match -rq '^[0-9]+ - .+ - .+' -- (basename "$f" .mp3)
            return 1
        end
    end
    return 0
end

function rip-cd
    set -l STAGING "$HOME/Music/staging"
    set -l START_TS (date +%s)
    set -l _abort_flag_path "/tmp/rip-cd-abort-$fish_pid"

    function _rip_cd_abort --on-signal INT
        echo ""
        echo "⛔ Cancelled. Staged files (if any) are still in $STAGING — nothing was moved."
        touch "$_abort_flag_path"
    end

    function _check_abort
        if test -f "$_abort_flag_path"
            functions --erase _rip_cd_abort _check_abort
            rm -f "$_abort_flag_path"
            return 1
        end
        return 0
    end

    echo "💿 Starting rip into staging..."
    abcde -B
    or begin
        if test -f "$_abort_flag_path"
            functions --erase _rip_cd_abort _check_abort
            rm -f "$_abort_flag_path"
            return 130
        end
        echo "❌ ERROR: abcde failed"
        functions --erase _rip_cd_abort _check_abort
        return 1
    end
    _check_abort; or return 130

    set -l NEW_FILES (find "$STAGING" -type f -name '*.mp3' -newermt "@$START_TS" | sort)
    if test (count $NEW_FILES) -eq 0
        echo "❌ ERROR: No new MP3 files found in staging"
        functions --erase _rip_cd_abort _check_abort
        return 1
    end
    set -l TOTAL_TRACKS (count $NEW_FILES)
    echo "🎵 Found $TOTAL_TRACKS new track(s) in staging"

    set -l FILE_TITLES
    set -l IS_VA 0
    if _files_are_va $NEW_FILES
        set IS_VA 1
        for f in $NEW_FILES
            set -l t (clean_text (string replace -r '^[0-9]+ - [^-]+ - ' '' (basename "$f" .mp3)))
            set -a FILE_TITLES $t
        end
    else
        for f in $NEW_FILES
            set -l t (clean_text (string replace -r '^[0-9]+ - ' '' (basename "$f" .mp3)))
            set -a FILE_TITLES $t
        end
    end

    set -l ARTIST ""
    set -l ALBUM ""
    set -l YEAR ""
    set -l RGID ""
    set -l MB_TRACKS_JSON "[]"
    set -l ABCDE_HAD_DATA 0

    if not _titles_are_generic $FILE_TITLES
        echo ""
        echo "✅ abcde identified the disc — track titles look good."
        echo "📌 Tracks: $FILE_TITLES[1] ... $FILE_TITLES[$TOTAL_TRACKS]"
        echo ""

        set -l tag_data (_read_tags_from_file $NEW_FILES[1])
        if test -n "$tag_data[1]"; set ARTIST "$tag_data[1]"; end
        if test -n "$tag_data[2]"; set ALBUM  "$tag_data[2]"; end
        if test -n "$tag_data[3]"; set YEAR   "$tag_data[3]"; end

        # For VA discs, override any partial/wrong tag artist with the canonical value
        if test $IS_VA -eq 1
            set ARTIST "Various Artists"
        end

        set ABCDE_HAD_DATA 1

        if test -n "$ARTIST"
            read -l -P "🎤 Artist [$ARTIST]: " IN; _check_abort; or return 130
            if test -n "$IN"; set ARTIST (clean_text "$IN"); end
        else
            read -l -P "🎤 Artist: " IN; _check_abort; or return 130
            while test -z "$IN"
                read -l -P "🎤 Artist: " IN; _check_abort; or return 130
            end
            set ARTIST (clean_text "$IN")
        end

        if test -n "$ALBUM"
            read -l -P "💿 Album [$ALBUM]: " IN; _check_abort; or return 130
            if test -n "$IN"; set ALBUM (clean_text "$IN"); end
        else
            read -l -P "💿 Album: " IN; _check_abort; or return 130
            while test -z "$IN"
                read -l -P "💿 Album: " IN; _check_abort; or return 130
            end
            set ALBUM (clean_text "$IN")
        end

        if test -n "$YEAR"
            read -l -P "📅 Year [$YEAR]: " IN; _check_abort; or return 130
            if test -n "$IN"; set YEAR $IN; end
        else
            read -l -P "📅 Year: " IN; _check_abort; or return 130
            while test -z "$IN"
                read -l -P "📅 Year: " IN; _check_abort; or return 130
            end
            set YEAR $IN
        end

    else
        set -l MID_IDX (math --scale=0 "$TOTAL_TRACKS / 2")
        set -l ANCHOR_TITLE $FILE_TITLES[$MID_IDX]
        echo ""
        echo "📌 Using track $MID_IDX as search anchor: \"$ANCHOR_TITLE\""

        read -l -P "🎤 Artist hint for search (leave blank to search title only): " ARTIST_HINT
        _check_abort; or return 130
        read -l -P "🌍 Country filter (ISO code e.g. ES, FR, US — leave blank for all): " MB_COUNTRY
        _check_abort; or return 130
        set MB_COUNTRY (string upper -- (string trim -- "$MB_COUNTRY"))

        echo "🔍 Searching MusicBrainz by recording title..."
        set -l mb_raw (mb_lookup_by_recording "$ANCHOR_TITLE" "$ARTIST_HINT" "$MB_COUNTRY")
        _check_abort; or return 130
        set -l result_count (echo $mb_raw | jq '.releases | length')

        if test "$result_count" -eq 0
            echo "  ⚠️  Recording search returned nothing, falling back to text search..."
            read -l -P "🔍 Album search query: " MB_QUERY; _check_abort; or return 130
            if test -n "$MB_QUERY"
                set mb_raw (mb_lookup_release "$MB_QUERY" "$MB_COUNTRY")
                _check_abort; or return 130
                set result_count (echo $mb_raw | jq '.releases | length')
            end
        end

        if test "$result_count" -gt 0
            set -l sorted_json (echo $mb_raw | jq -c \
                --argjson total $TOTAL_TRACKS \
                --arg country "$MB_COUNTRY" \
                '[.releases | to_entries[] | .value += {_orig: .key}] | sort_by(
                    (if .value["track-count"] == $total then 0 else 1 end),
                    (if ($country != "" and .value.country == $country) then 0 else 1 end),
                    .value._orig
                ) | map(.value)')
            _show_releases "$sorted_json" "$TOTAL_TRACKS" "$MB_COUNTRY"

            read -l -P "🔢 Choose release [1]: " CHOICE; _check_abort; or return 130
            if test -z "$CHOICE"; set CHOICE 1; end

            if test "$CHOICE" != "0"
                set -l idx (math $CHOICE - 1)
                set ARTIST       (echo $sorted_json | jq -r ".[$idx][\"artist-credit\"][0].artist.name // empty")
                set ALBUM        (echo $sorted_json | jq -r ".[$idx].title // empty")
                set YEAR         (echo $sorted_json | jq -r ".[$idx].date // empty" | string match -r '^[0-9]{4}')
                set RGID         (echo $sorted_json | jq -r ".[$idx][\"release-group\"].id // empty")
                set -l CHOSEN_RELID (echo $sorted_json | jq -r ".[$idx].id // empty")

                if test -n "$CHOSEN_RELID"
                    sleep 1; _check_abort; or return 130
                    set -l ua "rip-cd/1.0 ( https://github.com/itzi97/dotfiles )"
                    set -l rel_detail (curl -s -A "$ua" "https://musicbrainz.org/ws/2/release/$CHOSEN_RELID?inc=recordings&fmt=json")
                    _check_abort; or return 130
                    set MB_TRACKS_JSON (echo $rel_detail | jq -c '[.media[0].tracks[] | {pos: (.position | tonumber), title: .title}]')
                    echo "  🎶 Got "(echo $MB_TRACKS_JSON | jq 'length')" track titles from MusicBrainz"
                end
            end
        else
            echo "  ⚠️  No results found, you'll be prompted for all metadata"
        end

        if test -n "$ARTIST"
            read -l -P "🎤 Artist [$ARTIST]: " IN; _check_abort; or return 130
            if test -n "$IN"; set ARTIST (clean_text "$IN"); end
        else
            read -l -P "🎤 Artist [required]: " IN; _check_abort; or return 130
            while test -z "$IN"
                read -l -P "🎤 Artist [required]: " IN; _check_abort; or return 130
            end
            set ARTIST (clean_text "$IN")
        end

        if test -n "$ALBUM"
            read -l -P "💿 Album [$ALBUM]: " IN; _check_abort; or return 130
            if test -n "$IN"; set ALBUM (clean_text "$IN"); end
        else
            read -l -P "💿 Album [required]: " IN; _check_abort; or return 130
            while test -z "$IN"
                read -l -P "💿 Album [required]: " IN; _check_abort; or return 130
            end
            set ALBUM (clean_text "$IN")
        end

        if test -n "$YEAR"
            read -l -P "📅 Year [$YEAR]: " IN; _check_abort; or return 130
            if test -n "$IN"; set YEAR $IN; end
        else
            read -l -P "📅 Year [required]: " IN; _check_abort; or return 130
            while test -z "$IN"
                read -l -P "📅 Year [required]: " IN; _check_abort; or return 130
            end
            set YEAR $IN
        end
    end

    # --- Genre ---
    set -l GENRE ""
    if test -n "$RGID"
        echo "🔍 Looking up genre..."
        set GENRE (mb_lookup_genre "$RGID")
        _check_abort; or return 130
    end
    if test -n "$GENRE"
        echo "🎸 Found genre: $GENRE"
        read -l -P "🎸 Use '$GENRE'? [Y/n/other]: " IN; _check_abort; or return 130
        switch (string lower -- $IN)
            case '' y yes
            case n no; set GENRE ""
            case '*';  set GENRE (clean_text "$IN")
        end
    else
        read -l -P "🎸 Genre [skip]: " IN; _check_abort; or return 130
        if test -n "$IN"; set GENRE (clean_text "$IN"); end
    end

    # --- Release type ---
    echo ""
    echo "📂 Release type:"
    echo "   [1] Album        [2] Compilation"
    echo "   [3] Single       [4] EP"
    echo "   [5] Live         [6] Soundtrack"
    echo "   [0] Skip"
    # Pre-select compilation for VA discs
    set -l type_default 1
    if test $IS_VA -eq 1; set type_default 2; end
    read -l -P "📂 Type [$type_default]: " IN; _check_abort; or return 130
    if test -z "$IN"; set IN $type_default; end
    set -l RELEASE_TYPE ""
    set -l IS_COMPILATION 0
    switch "$IN"
        case 1; set RELEASE_TYPE album
        case 2; set RELEASE_TYPE compilation; set IS_COMPILATION 1
        case 3; set RELEASE_TYPE single
        case 4; set RELEASE_TYPE ep
        case 5; set RELEASE_TYPE live
        case 6; set RELEASE_TYPE soundtrack
        case 0
    end
    if test -n "$RELEASE_TYPE"; echo "   → $RELEASE_TYPE"; end

    # --- Disc info ---
    set -l DISC_TOTAL 1
    set -l DISC_NUM 1
    set -l MULTI_DISC 0
    read -l -P "💽 Single CD? [Y/n]: " IN; _check_abort; or return 130
    switch (string lower -- $IN)
        case '' y yes
        case '*'
            set MULTI_DISC 1
            read -l -P "💽 Total discs [2]: " IN; _check_abort; or return 130
            if test -n "$IN"; set DISC_TOTAL $IN; else; set DISC_TOTAL 2; end
            read -l -P "💽 This disc number [1]: " IN; _check_abort; or return 130
            if test -n "$IN"; set DISC_NUM $IN; else; set DISC_NUM 1; end
    end

    # --- Manual titles if still generic ---
    set -l MANUAL_TITLES
    if test "$MB_TRACKS_JSON" = "[]" -a "$ABCDE_HAD_DATA" -eq 0
        if _titles_are_generic $FILE_TITLES
            echo ""
            echo "⚠️  Track titles are generic and no MusicBrainz data was found."
            read -l -P "✏️  Enter track titles manually? [Y/n]: " IN; _check_abort; or return 130
            if not string match -rqi '^n' -- "$IN"
                echo "   Enter each title and press Enter. Leave blank to keep 'Track N'."
                for i in (seq 1 $TOTAL_TRACKS)
                    read -l -P (printf "   Track %02d: " $i) MTITLE; _check_abort; or return 130
                    if test -n "$MTITLE"
                        set -a MANUAL_TITLES (clean_text "$MTITLE")
                    else
                        set -a MANUAL_TITLES $FILE_TITLES[$i]
                    end
                end
            end
        end
    end

    # --- Build target dir ---
    set -l TARGET_DIR "$HOME/Music/mp3/$ARTIST/$YEAR - $ALBUM"
    if test "$ARTIST" = "Various Artists"
        set TARGET_DIR "$HOME/Music/mp3/Various Artists/$YEAR - $ALBUM"
    end
    if test $MULTI_DISC -eq 1; set TARGET_DIR "$TARGET_DIR/CD$DISC_NUM"; end
    mkdir -p "$TARGET_DIR"
    echo "📁 Target: $TARGET_DIR"

    # --- Tag and move ---
    echo "🏷️  Tagging and moving tracks..."
    set -l i 0
    for file in $NEW_FILES
        _check_abort; or return 130
        set i (math $i + 1)
        set -l base (basename "$file" .mp3)
        set -l TRACKNUM (string match -r '^[0-9]+' "$base")
        set -l TRACKNUM_INT (math $TRACKNUM + 0)

        set -l TITLE ""
        if test "$MB_TRACKS_JSON" != "[]"
            set TITLE (echo $MB_TRACKS_JSON | jq -r --argjson n $TRACKNUM_INT '.[] | select(.pos == $n) | .title // empty')
        end
        if test -z "$TITLE" -a (count $MANUAL_TITLES) -ge $i
            set TITLE $MANUAL_TITLES[$i]
        end

        if test "$ARTIST" = "Various Artists"
            set -l TRACKARTIST (clean_text (string replace -r '^[0-9]+ - ([^-]+) - .*$' '$1' "$base"))
            if test -z "$TITLE"; set TITLE $FILE_TITLES[$i]; end
            eyeD3 -a "$TRACKARTIST" -b "Various Artists" -A "$ALBUM" -Y "$YEAR" -t "$TITLE" -n "$TRACKNUM" -N "$TOTAL_TRACKS" -d "$DISC_NUM" -D "$DISC_TOTAL" "$file"
            and begin
                mv "$file" "$TARGET_DIR/"
                echo "  ✅ $TRACKNUM/$TOTAL_TRACKS - $TRACKARTIST — $TITLE"
            end
            or echo "  ⚠️  Failed to tag: $base"
        else
            if test -z "$TITLE"; set TITLE $FILE_TITLES[$i]; end
            eyeD3 -a "$ARTIST" -b "$ARTIST" -A "$ALBUM" -Y "$YEAR" -t "$TITLE" -n "$TRACKNUM" -N "$TOTAL_TRACKS" -d "$DISC_NUM" -D "$DISC_TOTAL" "$file"
            and begin
                mv "$file" "$TARGET_DIR/"
                echo "  ✅ $TRACKNUM/$TOTAL_TRACKS - $TITLE"
            end
            or echo "  ⚠️  Failed to tag: $base"
        end
    end

    if test -n "$GENRE"
        echo "🎸 Applying genre: $GENRE"
        eyeD3 -G "$GENRE" "$TARGET_DIR"/*.mp3
    end
    if test -n "$RELEASE_TYPE"
        echo "📂 Applying release type: $RELEASE_TYPE"
        eyeD3 --set-text-frame="TXXX:MusicBrainz Album Type:$RELEASE_TYPE" "$TARGET_DIR"/*.mp3 2>/dev/null
    end
    if test "$IS_COMPILATION" -eq 1
        eyeD3 --set-text-frame=TCMP:1 "$TARGET_DIR"/*.mp3 2>/dev/null
    end

    find "$STAGING" -type d -empty -delete 2>/dev/null
    functions --erase _rip_cd_abort _check_abort
    rm -f "$_abort_flag_path"
    echo "✨ Done: $TARGET_DIR"
end
