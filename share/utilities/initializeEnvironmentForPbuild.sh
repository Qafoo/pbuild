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
# Use the name of a pbuild file to initialize the needed build environment
#
# This functions sets the following global variables: PBUILD, PB, PN, PV, and
# PE
#
# PBUILD: full build path
# PB: name of the pbuild (without extension and path)
# PN: name of the "product" (usually php)
# PV: version string of the pbuild
# PE: extra buildname of the pbuild (everything that comes after a minus behind
#     the version string)
#
# @param pbuild
##
initializeEnvironmentForPbuild() {
    local pbuild="$1"

    local regexp='s@^\([^-]\+\)-\(\([0-9]\+\.\)*[0-9]\+\)-\?\(.*\)$@'

    PBUILD="$pbuild"

    PB=$(basename "${pbuild}" ".pbuild")

    PN="$(echo "$PB"|sed -e "${regexp}\\1@")"
    PV="$(echo "$PB"|sed -e "${regexp}\\2@")"
    PE="$(echo "$PB"|sed -e "${regexp}\\4@")"
}
