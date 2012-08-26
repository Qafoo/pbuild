####
# Copyright (c) 2011-2012, Jakob Westhoff <jakob@qafoo.com>
# 
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#  - Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#  - Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
####

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
        plog -v "Falling back to pbuilds with a buildname"
        echo "$(getFirstArgument ${PBUILD_DIR}/${pattern}-*.pbuild)"
        return
    fi

    if [ -f "$(pwd)/${pattern}.pbuild" ]; then
        plog -v "Falling back to pbuilds in the current working directory"
        echo "$(readlink -f "$(pwd)/${pattern}.pbuild")"
        return
    fi

    if [ -f "$(getFirstArgument $(pwd)/${pattern}-*.pbuild)" ]; then
        plog -v "Falling back to pbuilds in the current working directory with a build name"
        echo "$(getFirstArgument $(pwd)/${pattern}-*.pbuild)"
        return
    fi

    perror "Could not find a pbuild identified by '${pattern}'. Giving up."
}
