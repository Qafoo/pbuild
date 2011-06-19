####
# Copyright (c) 2011, Jakob Westhoff <jakob@westhoffswelt.de>
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
# Fetch package from the given url
#
# The function automatically decides to either use wget or curl to fetch the
# package.
#
# Furthermore the fetched package will be automatically put inside the correct
# directory. Needed subdirectories are automatically created.
#
# If the second optional argument is not supplied the filename is extrapolated
# from the given url.
#
# @param url
# @param target
##
pfetch() {
    local url="$1"
    
    local target=""
    if [ $# -gt 1 ]; then
        local target=$2
    fi

    plog "Fetching ${url}"

    if [ ! -z "${target}" ]; then
        target="$(makeRelativeTo "${D}" "${target}")"
    fi

    # Check which download util we may utilize
    local CURL=""
    local WGET=""
    
    CURL="$(which "curl")"
    if [ $? -ne 0 ]; then
        WGET="$(which "wget")"
    fi

    if [ -z "${CURL}" ] && [ -z "${WGET}" ]; then
        perror "No downloader could be found on your system. Install either curl or wget."
    fi
    
    pushd "${D}" >/dev/null

    local subdir=$(dirname "${target}")
    if [ ! -e "${subdir}" ]; then
        mkdir -p "$subdir"
    fi
    
    cd "$subdir"

    local filename="$(basename "${target}")"

    if [ -z "${filename}" ]; then
        # Let the downloader decide the filename, as no special filename is
        # given
        if [ ! -z "${CURL}" ]; then
            ${CURL} --progress-bar -L -O "${url}"
        else
            ${WGET} -nd "${url}"
        fi
    else
        # The output filename is determined by the user
        if [ ! -z "${CURL}" ]; then
            ${CURL} --progress-bar -L -o "${filename}" "${url}"
        else
            ${WGET} -nd "${url}" -O "${filename}"
        fi
    fi

    popd >/dev/null

    if [ $? -ne 0 ]; then
        perror "Sorry the package could not be downloaded"
    fi
}
