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
# Unpack the given archive to the given destination automatically determining
# the correct way of decompression
#
# The destination is optional. If no destination is given the root of the ${D}
# directory is used. (This is the most likely needed outcome)
#
# @param archive
# @param target (directory)
##
punpack() {
    local archive="$(makeRelativeTo "${S}" "$1")"
    
    local target=""
    if [ $# -gt 1 ]; then
        local target="$(makeRelativeTo "${D}" "$2")"
    fi

    # TODO: Implement checks to support more than just tar archives in the
    # future

    plog "Decompressing archive: ${archive}"

    if [ ! -d "${D}"/"${target}" ]; then
        pmkdir -p "${D}"/"${target}"
    fi

    pushd "${D}"/"${target}" >/dev/null
    
    if ! tar -xf "${S}"/"${archive}"; then
        perror "Package archive could not be decompressed"
    fi

    popd >/dev/null
}
