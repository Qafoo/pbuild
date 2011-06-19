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
# Link a file from the PHP_DIR to the INSTALL_DIR
#
# If the target is omitted the source counterpart in the INSTALL_DIR will be
# chosen automatically
#
# @param source
# @param (target)
##
plink() {
    local source="$(makeRelativeTo "${S}" "${1}")"

    local target="${source}"
    if [ $# -gt 1 ]; then
        local target="$(makeRelativeTo "${D}" "${2}")"
    fi

    plog "Linking: ${source}"

    if [ -e "${D}/${target}" ]; then
        if [ "$(pask "Link target ${D}/${target} already exists. Overwrite? [y/N]" "yn" "n")" != "y" ]; then
            plog "Skipped linking ${source} due to user request"
            return
        fi
    fi

    ln -s "${S}/${source}" "${D}/${target}"
}
