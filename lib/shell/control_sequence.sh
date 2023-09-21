# Library for Linux console control sequences
#
# Requires: none

# https://man.archlinux.org/man/console_codes.4
readonly CS_INTRODUCER='\e['
readonly SGR_END='m'
readonly SGR_SEPARATOR=';'
readonly SGR_ATTR_RESET='0'
readonly SGR_ATTR_BOLD='1'
# https://en.wikipedia.org/wiki/ANSI_escape_code#256_color_table
readonly SGR_ATTR_COLOR_DARK_GREEN='38;5;28'
readonly SGR_ATTR_COLOR_RED='38;5;203'
readonly SGR_ATTR_COLOR_GRAY='38;5;244'
readonly SGR_ATTR_COLOR_BLUE='38;5;33'
readonly SGR_ATTR_COLOR_CYAN='38;5;44'
readonly SGR_ATTR_COLOR_MAGENTA='38;5;133'

# Concatenates a sequence of Select Graphic Rendition (SGR) attributes separated
# by `SGR_SEPARATOR`
#
# Globals:
#   SGR_SEPARATOR: read
# Arguments:
#   $1...: the SGR attributes (must provide at least one attribute)
# Outputs: the SGR control sequence
# Returns: default
control_sequence::concat_sgr_attrs() {
  local -r remaining_args=("${@:2}")
  printf '%s' "$1" "${remaining_args[@]/#/"${SGR_SEPARATOR}"}"
}

# Makes a Select Graphic Rendition (SGR) control sequence (e.g., to change the
# foreground color)
#
# Globals:
#   CS_INTRODUCER: read
#   SGR_END: read
# Arguments:
#   $1...: the SGR attributes (must provide at least one attribute)
# Outputs: the SGR control sequence
# Returns: default
control_sequence::sgr() {
  printf '%s' \
      "${CS_INTRODUCER}" \
      "$(control_sequence::concat_sgr_attrs "$@")" \
      "${SGR_END}"
}

# Commonly used control sequences:
readonly CS_SGR_RESET="$(control_sequence::sgr "${SGR_ATTR_RESET}")"
