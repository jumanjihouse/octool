################################################################################
# Style file for markdownlint.
#
# https://github.com/markdownlint/markdownlint/blob/master/docs/configuration.md
#
# This file is referenced by the project `.mdlrc`.
################################################################################

# Start with all built-in rules.
# https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md
all

# Override default parameters for some built-in rules.
# https://github.com/markdownlint/markdownlint/blob/master/docs/creating_styles.md#parameters

# Ignore line length in code blocks.
rule 'MD013', code_blocks: false

# I prefer two blank lines before each heading.
exclude_rule 'MD012' # Multiple consecutive blank lines

# I find it necessary to use '<br/>' to force line breaks.
exclude_rule 'MD033' # Inline HTML

# If a page is printed, it helps if the URL is viewable.
exclude_rule 'MD034' # Bare URL used

# Either disable this one or MD024 - Multiple headers with the same content.
exclude_rule 'MD036' # Emphasis used instead of a header

exclude_rule 'MD046' # Allow both fenced and indented code blocks.
