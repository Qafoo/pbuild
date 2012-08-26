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
# Make the given string relative to the given path
#
# To create a relative path the prefixing slash will be removed. Furthermore it
# will be checked if the string starts with the path (aka. is absolute) in this
# case the path prefix will be removed.
#
# The relative path must exist for this function to work.
#
# @param relative
# @param path
# @return path
##
makeRelativeTo() {
    local relative="$1"
    local path="$2"

    pushd "${relative}" >/dev/null
    
    local processed="${path}"

    # If the target has been specified with a full path to the destination
    # remove this path prefix.
    processed="$(echo "${processed}"|sed -e "s@^$(escapeForRegexp "${relative}")@@")"

    # Remove any prefixed slash to ensure we are inside the target dir. This
    # may create strange subdir structures, but it will make sure we have
    # a somewhat relative path.
    processed="$(echo "${processed}"|sed -e 's@^/*@@')"

    popd >/dev/null

    echo "${processed}"
}
