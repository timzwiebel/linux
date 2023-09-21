# Library for Bash prompts
#
# Requires:
#   lib/shell/control_sequence.sh

# `\[` and `\]` begin and end sequences of non-printing characters. These are
# needed so that line wrapping doesn't get messed up.
# https://tldp.org/HOWTO/Bash-Prompt-HOWTO/nonprintingchars.html
# Note that if control sequences are used from a subshell in the prompt, they
# will also need to indicate that they are sequences of non-printing characters.
# However, since the special bash prompt escape characters won't work in the
# subshell, `\[` and `\]` won't work either. In that case, use `\x01` and `\x02`
# which are `RL_PROMPT_START_IGNORE` and `RL_PROMPT_END_IGNORE` in the readline
# library used by bash. Prefer `\x01` and `\x02` over `\001` and `\002` because
# the latter can be ambiguous if followed by a digit. For example, `echo
# $'\0027'` is interpreted as two bytes: `02 37`. However, `echo -e '\0027'` is
# interpreted as one byte: `17`.
# https://tiswww.cwru.edu/php/chet/readline/readline.html#index-rl_005fexpand_005fprompt
readonly BASH_PROMPT_NON_PRINTING_START='\['
readonly BASH_PROMPT_NON_PRINTING_END='\]'

# https://man.archlinux.org/man/bash.1#PROMPTING
readonly BASH_PROMPT_TIME='\D{%Y-%m-%d %H:%M:%S %z}'
readonly BASH_PROMPT_ABBREVIATED_HOSTNAME='\h'
readonly BASH_PROMPT_JOB_COUNT='\j'
readonly BASH_PROMPT_SHELL_AND_VERSION='\s-\V'
readonly BASH_PROMPT_USER='\u'
readonly BASH_PROMPT_WORKING_DIRECTORY='\w'
readonly BASH_PROMPT_CHARACTER='\$'  # `#` if root user, otherwise `$`

# Wraps a control sequence so that it is treated as a sequence of "non-printing
# characters"
#
# Globals:
#   BASH_PROMPT_NON_PRINTING_START: read
#   BASH_PROMPT_NON_PRINTING_END: read
# Arguments:
#   $1: the control sequence
# Outputs: the wrapped control sequence
# Returns: default
bash_prompt::wrap_cs() {
  printf '%s' \
      "${BASH_PROMPT_NON_PRINTING_START}" "$1" "${BASH_PROMPT_NON_PRINTING_END}"
}

# Makes a Select Graphic Rendition (SGR) control sequence (e.g., to change the
# foreground color) and calls `bash_prompt::wrap_cs` so that it is treated as a
# sequence of "non-printing characters"
#
# Globals:
#   bash_prompt::wrap_cs: call
#   control_sequence::sgr: call
# Arguments:
#   $1...: the SGR attributes (must provide at least one attribute)
# Outputs: the SGR control sequence as "non-printing characters"
# Returns: default
bash_prompt::sgr() {
  printf '%s' "$(bash_prompt::wrap_cs "$(control_sequence::sgr "$@")")"
}

# Formats text by prepending a (wrapped) Select Graphic Rendition (SGR) control
# sequence and appending `BASH_PROMPT_CS_RESET`
#
# Globals:
#   BASH_PROMPT_CS_RESET: read
#   bash_prompt::sgr: call
# Arguments:
#   $1: the text to format
#   $2...: the SGR attributes (must provide at least one attribute)
# Outputs: the text wrapped in SGR control sequences
# Returns: default
bash_prompt::format_text() {
  printf '%s' "$(bash_prompt::sgr "${@:2}")" "$1" "${BASH_PROMPT_CS_RESET}"
}

# Commonly used control sequences:
readonly BASH_PROMPT_CS_RESET="$(bash_prompt::wrap_cs "${CS_SGR_RESET}")"
