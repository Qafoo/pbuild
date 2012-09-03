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
# Exec any executable from within the currently build php version
#
# @param executable
# @param argument, ...
##
pbin() {
    local executable="${1}"
    shift 1

    if [ -f "${P}/sbin/${executable}" ]; then
        executable="${P}/sbin/${executable}"
    elif [ -f "${P}/bin/${executable}" ]; then
        executable="${P}/bin/${executable}"
    else
        perror "Could not locate '${executable}' wihtin your current php build for execution."
    fi

    plog -v "Executing: ${executable} ${*}"

    ${executable} "${@}"
}

##
# All kinds of aliases for the usually needed commands
##
pphp() {
    pbin php "${@}"
}
ppear() {
    if [ "${1}" = "install" ]; then
        eval "plog \"Installing pear package: \${${#}}\""
    fi
    pbin pear -q "${@}"
}
ppecl() {
    if [ "${1}" = "install" ]; then
        eval "plog \"Installing pecl package: \${${#}}\""
    fi
    pbin pecl -q "${@}"
}
ppeardev() {
    pbin peardev "${@}"
}
pphar() {
    pbin phar "${@}"
}
pphpize() {
    pbin phpize "${@}"
}
