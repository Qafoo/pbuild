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
# Ask the user a question and return his/her answer
#
# The second argument is optional. It specified a string containing all valid
# inputs. It can only be used if the questions answer is a one character
# string. For example a simply yes/no question (y/n). If the second argument is
# specified only one character answers matching the given characters are valid
# answers. Everything else will be rejected.
#
# If a one character check is done the given input is lowercased before checked
# against the allowed characters
#
# The third optional argument specifies a default value, which is used in case
# the user just presses the enter button without providing any input at all.
#
# @param question
# @param (allowed)
# @param (default)
##
pask() {
    local question="$1"

    local allowed=""
    if [ $# -gt 1 ]; then
        allowed="$2"
    fi

    local default=""
    if [ $# -gt 2 ]; then
        default="$3"
    fi

    local input=""

    local accepted=1
    while [ $accepted -ne 0 ]; do
        colorize -n "[<blue>?</blue>] ${question} " >&42
        read input

        if [ -z "$input" ]; then
            input="${default}"
        fi

        if [ -z "$allowed" ]; then
            accepted=0
        else
            input="$(echo "${input}"|tr '[A-Z]' '[a-z]')"

            local allowedBoundary=${#allowed}
            let allowedBoundary=allowedBoundary-1
            local i=0            
            for i in $(seq 0 ${allowedBoundary}); do
                if [ "${allowed:$i:1}" = "${input}" ]; then
                    accepted=0
                    break
                fi
            done

            if [ $accepted -ne 0 ]; then
                plog "The given answer is invalid. Possible answers are: ${allowed}"
            fi
        fi
    done

    echo "${input}"
}
