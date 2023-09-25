# https://github.com/markdownlint/markdownlint/blob/main/docs/configuration.md
# https://github.com/markdownlint/markdownlint/blob/main/docs/creating_styles.md

# Use all rules by default.
all

# header-style: Prefer preceding headers with some number of `#`.
rule 'MD003', :style => :atx

# ul-style: Prefer using `-` for unordered lists.
rule 'MD004', :style => :dash

# ul-indent: Use 4 spaces for nested (unordered) lists.
#
# When combined with MD005 (list-indent; requires all list items at the same
# level to use the same indentation), this will results in all list items being
# indented exactly 4 spaces per level, not just unordered lists.
#
# The reason to use 4 spaces is for convenience when using the TAB key with an
# editor where tabs stops are every 2 spaces. The value must be at least 3
# because `'1. '` (for ordered lists) is 3 characters, so 4 is the first
# multiple of 2 greater than 3.
rule 'MD007', :indent => 4

# no-trailing-spaces: Prefer `<br>` instead of 2 trailing spaces for explicit
# line breaks since trailing whitespace is difficult to notice and many editors
# will remove trailing whitespace by default.
rule 'MD009', :br_spaces => 0

# no-hard-tabs: Prefer spaces,

# single-h1: Allow multiple `h1` headers since we're not necessarily using the
# convention that the top-level header on the first line is the title of the
# document.
exclude_rule 'MD025'

# no-trailing-punctuation: Disable punctuation at the end of headers, except for
# `?` which might be used in an FAQ.
rule 'MD026', :punctuation => '.,;:!'

# no-blanks-blockquote: Allow blank lines inside blockquotes. Sometimes you
# really do just want two back-to-back blockquotes.
exclude_rule 'MD028'

# ol-prefix: Prefer each item to start with `1.` in an ordered list (instead of
# `1.`, `2.`, `3.`).
rule 'MD029', :style => :one

# list-marker-space: Prefer 1 space after `-` for unordered lists and 2 spaces
# after `1.` for ordered lists. This way, the text for each list item starts on
# an odd column (i.e., `-` for `ul` and `1.` for `ol` start on columns 1, 5, 9,
# ...; `ul` item text starts on columns 3, 7, 11, ...; ol item text starts on
# columns 5, 9, 13, ...). For example:
#
# ```
#   - ul item 1
#   - ul item 2
#       - ul item 3
#   - ul item 4
#
#   1.  ol item 1
#   1.  ol item 2
#       1.  ol item 3
#   1.  ol item 4
# ```
rule 'MD030', :ul_single => 1, :ol_single => 2, :ul_multi => 1, :ol_multi => 2

# no-inline-html: Allow `<br>` for explicit line breaks.
rule 'MD033', :allowed_elements => 'br'

# hr-style: Prefer `---` for horizontal rules.
rule 'MD035', :style => '---'
