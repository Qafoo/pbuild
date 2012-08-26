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
# Execute a configure run with the specified user configuration arguments
# adding all the needed prefixs and type flags.
#
# An arbitrary amount of arguments is accepted. All of those are passed through
# to the configure call
##
pconfigure() {
    # No changes in directory are made inside of this function to allow the
    # pbuild creator to change to the src directory of his chosing.
    
    # Variable and forced configure options exist. Variable ones may be
    # overridden by the options given to the pconfigure function forced ones
    # may not.
    local variableOptions=""
    local forcedOptions=""

    # A cli build is required for all types, as it is needed to be able to
    # install pear packages and stuff, while automatically maintaining the
    # correct target and include paths.
    forcedOptions="${forcedOptions} --enable-cli"

    # The type to build is encoded inside the ${PT} variable
    # Please take into account that some of those configure options were
    # removed and/or modified in different php versions. Unknown configure
    # options do not hurt however, therefore some of them like --enable-fastcgi
    # are still here in order to work with older versions of php
    # Furthermore the cli-build is enabled by default in all incarnations, as
    # the executable is quite useful to install pear packages and stuff like
    # that inside the correct directories without careing about it.
    case "${PT}" in
        "fpm")
            forcedOptions="${forcedOptions} --enable-cgi"
            variableOptions="${variableOptions} --enable-force-cgi-redirect"
            forcedOptions="${forcedOptions} --enable-fastcgi"
            forcedOptions="${forcedOptions} --enable-fpm"
            variableOptions="${variableOptions} --enable-cli"
        ;;
        "fcgi")
            forcedOptions="${forcedOptions} --enable-cgi"
            variableOptions="${variableOptions} --enable-force-cgi-redirect"
            forcedOptions="${forcedOptions} --enable-fastcgi"
            variableOptions="${variableOptions} --enable-cli"
        ;;
        "cli")
            forcedOptions="${forcedOptions} --disable-fpm"
            forcedOptions="${forcedOptions} --disable-cgi"
            forcedOptions="${forcedOptions} --disable-fastcgi"
        ;;
        "apxs")
            forcedOptions="${forcedOptions} --with-apxs"
            forcedOptions="${forcedOptions} --disable-cgi"
            variableOptions="${variableOptions} --enable-cli"
        ;;
        "apxs2")
            forcedOptions="${forcedOptions} --with-apxs2"
            forcedOptions="${forcedOptions} --disable-cgi"
            variableOptions="${variableOptions} --enable-cli"
        ;;
        *)
            perror "Tried to configure unknown build type: ${PT}"
    esac

    # Configure all the needed prefixes and directories
    forcedOptions="${forcedOptions} --with-libdir=lib/x86_64-linux-gnu --with-libdir=lib/i386-linux-gnu --with-libdir=lib"
    # ${PB} contains the used pbuild name in full (aka. php-5.3.6-buildname)
    forcedOptions="${forcedOptions} '--prefix=${PHP_DIR}/${PB}_${PT}'"
    forcedOptions="${forcedOptions} '--with-pear=${PHP_DIR}/${PB}_${PT}'"
    forcedOptions="${forcedOptions} '--with-config-file-path=${PHP_CONFIG_DIR}/${PB}_${PT}'"
    plog "Running configure: ./configure" "${variableOptions}" "$@" "${forcedOptions}"

    if ! eval "./configure" "${variableOptions}" "$@" "${forcedOptions}"; then
        perror "Configure failed"
    fi
}
