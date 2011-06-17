##
# Find a certain pbuild file based on a given pattern
#
# Different tests for locating the correct pbuild file are executed. The tests
# are run in the given order:
#
# 1. The given pattern is checked as realpath
# 2. Check for a file called <pattern>.pbuild in the PBUILD_DIR
# 3. Check for a file called <pattern>-*.pbuild in the PBUILD_DIR (If multiple
#    files are found the first one will be used)
# 4. Check for a file called <pattern>.pbuild in the CWD
# 5. Check for a file called <pattern>-*.pbuild in the CWD (If multiple files
#    are found the first one will be used)
#
# @param pattern
# @return realpath of the pbuild
##
findpbuild() {
    local pattern=$1

    if [ -f "${pattern}" ]; then
        echo "$(readlink -f "${pattern}")"
        return;
    fi

    if [ -f "${PBUILD_DIR}/${pattern}.pbuild" ]; then
        echo "$(readlink -f "${PBUILD_DIR}/${pattern}.pbuild")"
        return
    fi

    if [ -f "$(getFirstArgument ${PBUILD_DIR}/${pattern}-*.pbuild)" ]; then
        plog "Falling back to pbuilds with a buildname"
        echo "$(getFirstArgument ${PBUILD_DIR}/${pattern}-*.pbuild)"
        return
    fi

    if [ -f "$(pwd)/${pattern}.pbuild" ]; then
        plog "Falling back to pbuilds in the current working directory"
        echo "$(readlink -f "$(pwd)/${pattern}.pbuild")"
        return
    fi

    if [ -f "$(getFirstArgument $(pwd)/${pattern}-*.pbuild)" ]; then
        plog "Falling back to pbuilds in the current working directory with a build name"
        echo "$(getFirstArgument $(pwd)/${pattern}-*.pbuild)"
        return
    fi

    perror "Could not find a pbuild identified by '${pattern}'. Giving up."
}
