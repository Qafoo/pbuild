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
# Print some sort of log message
#
# The -v option may be used to indicate a verbose logging operation. Those
# logging output will only be displayed, if the user specifies the -v flag as
# well.
#
# @option -v
# @param message
##
plog() {
    local verbose_option=""
    OPTIND=0
    local option=""
    while getopts ":v" option; do
        case "${option}" in
            v) verbose_option="SET";;
            *) perror "Invalid option given to plog";;
        esac
    done
    shift $((OPTIND-1))

    local message="$@"

    if [ ! -z "${verbose_option}" ] && [ ! -z "${VERBOSE}" ]; then
        echo -e "[\033[38;5;10m>\033[0m] ${message}" >&42
        return
    fi

    if [ -z "${verbose_option}" ]; then
        echo -e "[\033[38;5;10m>\033[0m] ${message}" >&42
    fi
}
