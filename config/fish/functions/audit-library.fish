function audit-library
    # Resolve audit_library.py relative to this file's REAL location, so it works
    # through the dotbot symlink at ~/.config/fish/functions/audit-library.fish.
    #
    # Layout depth changed when this moved out of the old stow repo:
    #   old  <repo>/fish/.config/fish/functions/  -> ../../../../scripts
    #   new  <repo>/config/fish/functions/        -> ../../../scripts
    set -l _this (realpath (status --current-filename) 2>/dev/null; or status --current-filename)
    set -l SCRIPT (realpath (dirname $_this)/../../../scripts/audit_library.py 2>/dev/null)

    # Fallback for the conventional checkout location.
    if not test -f "$SCRIPT"
        set SCRIPT "$HOME/.dotfiles/scripts/audit_library.py"
    end

    if set -q AUDIT_LIBRARY_SCRIPT
        set SCRIPT $AUDIT_LIBRARY_SCRIPT
    end

    if not test -f "$SCRIPT"
        echo "audit-library: cannot find audit_library.py"
        echo "  Expected: $SCRIPT"
        echo "  Override: set -x AUDIT_LIBRARY_SCRIPT /path/to/audit_library.py"
        return 1
    end

    set -l ARGS
    for arg in $argv
        set -a ARGS $arg
    end
    # Default when no folder was given. The second clause matters: `audit-library
    # --dry-run` on its own must still get a path, or the auditor is handed a flag
    # and nothing to audit. The old stow copy had this; an earlier port dropped it.
    if test (count $ARGS) -eq 0
        or begin
            test (count $ARGS) -eq 1
            and test "$ARGS[1]" = "--dry-run"
        end
        set -a ARGS "$HOME/Music/mp3"
        echo "No folder given — defaulting to $HOME/Music/mp3"
    end

    python3 $SCRIPT $ARGS
end
