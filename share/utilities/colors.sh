# Escape codes
COLOR_START="\033["
COLOR_END="m"

# Default colors
COLOR_BLUE="0;34"
COLOR_GREEN="0;32"
COLOR_CYAN="0;36"
COLOR_RED="0;31"
COLOR_PURPLE="0;35"
COLOR_YELLOW="0;33"
COLOR_GRAY="1;30"
COLOR_LIGHT_BLUE="1;34"
COLOR_LIGHT_GREEN="1;32"
COLOR_LIGHT_CYAN="1;36"
COLOR_LIGHT_RED="1;31"
COLOR_LIGHT_PURPLE="1;35"
COLOR_LIGHT_YELLOW="1;33"
COLOR_LIGHT_GRAY="0;37"

# Somewhat special colors
COLOR_BLACK="0;30"
COLOR_WHITE="1;37"
COLOR_NONE="0"

##
# Add escape sequences to defined color codes
#
# Must never be called outside of this script, as it only is allowed to be
# called once
#
# It's only a function to allow local variables
##
COLOR_add_escape_sequences() {
    local color
    for color in BLUE GREEN CYAN RED PURPLE YELLOW GRAY; do
        eval "COLOR_${color}=\"\${COLOR_START}\${COLOR_${color}}\${COLOR_END}\""
        eval "COLOR_LIGHT_${color}=\"\${COLOR_START}\${COLOR_LIGHT_${color}}\${COLOR_END}\""
    done

    for color in BLACK WHITE NONE; do
        eval "COLOR_${color}=\"\${COLOR_START}\${COLOR_${color}}\${COLOR_END}\""
    done
}

COLOR_add_escape_sequences
