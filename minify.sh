#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

COPYRIGHT_TOP='"""
(C) Copyright 2021 - Privex Inc.   https://www.privex.io
PIPWrapper is released under the X11 / MIT License
Official Repo: https://github.com/Privex/pipwrapper
"""
'

COPYRIGHT='\n\t"""'
COPYRIGHT+='\n\t(C) Copyright 2021 - Privex Inc.   https:\/\/www.privex.io'
COPYRIGHT+='\n\tPIPWrapper is released under the X11 \/ MIT License'
COPYRIGHT+='\n\tOfficial Repo: https:\/\/github.com\/Privex\/pipwrapper'
COPYRIGHT+='\n\t"""'

SYSNAME="$(uname -s)"
: ${MIN_FILE="${DIR}/pipwrapper/pipwrapper.py"}
: ${SED_REPL_LEFT='class Pip\(object\):'}
: ${SED_REPL_RIGHT="class Pip(object):${COPYRIGHT}"}

: ${MIN_REMOVE_LIT=1}
: ${MIN_RENAME_LOCALS=0}
: ${MIN_REMOVE_OBJ=0}
: ${MIN_HOIST_LITERALS=0}
MIN_ARGS=()
(( MIN_REMOVE_LIT )) && MIN_ARGS+=("--remove-literal-statements")
(( MIN_RENAME_LOCALS )) || MIN_ARGS+=("--no-rename-locals")
(( MIN_REMOVE_OBJ )) || MIN_ARGS+=("--no-remove-object-base")
(( MIN_HOIST_LITERALS )) || MIN_ARGS+=("--no-hoist-literals")


has_command() {
    command -v "$@" &> /dev/null
}

xsed() {
    if [[ "$SYSNAME" == "Linux" ]]; then
        if has_command gsed; then
            gsed "$@"
        else
            sed "$@"
        fi
    else
        if has_command gsed; then
            gsed "$@"
        else
            >&2 echo -e "\n [!!!] WARNING: Non-Linux system detected, and 'gsed' (GNU SED) wasn't found!"
            >&2 echo -e " [!!!] Please install the package 'gsed' or 'gnu-sed' (package name may vary by OS/Distro) if it's available, to avoid issues"
            >&2 echo -e " [!!!] related to the use of BSD SED instead of GNU SED."
            >&2 echo -e " [!!!] Falling back to standard 'sed' - which may be BSD SED and may not work as expected...\n"
            sed "$@"
        fi
    fi

}

#cat <<< "s/${SED_REPL_LEFT}/${SED_REPL_RIGHT}/"

cat <<< "${COPYRIGHT_TOP}"
pyminify "${MIN_ARGS[@]}" "$MIN_FILE" | xsed -E "s/${SED_REPL_LEFT}/${SED_REPL_RIGHT}/"
