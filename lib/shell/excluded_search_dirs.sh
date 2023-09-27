# Library for defining `EXCLUDED_SEARCH_DIRS``, an array of directories to be
# excluded while searching.
#
# Requires: none

EXCLUDED_SEARCH_DIRS=('.git')
EXCLUDED_SEARCH_DIRS+=('.history')
EXCLUDED_SEARCH_DIRS+=('.svelte-kit')
EXCLUDED_SEARCH_DIRS+=('node_modules')
readonly EXCLUDED_SEARCH_DIRS
