# Library for defining `_EXCLUDED_SEARCH_DIRS``, an array of directories to be
# excluded while searching.
#
# Requires: none

_EXCLUDED_SEARCH_DIRS=('.git')
_EXCLUDED_SEARCH_DIRS+=('.history')
_EXCLUDED_SEARCH_DIRS+=('.svelte-kit')
_EXCLUDED_SEARCH_DIRS+=('node_modules')
readonly _EXCLUDED_SEARCH_DIRS
