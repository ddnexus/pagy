# This file adds support for multiple built-in plualiztion types.
# It defines the pluralization procs and gets eval(ed) at I18N.load time
# frozen_string_literal: true

# utility variables
zero_one = ['zero', 'one']

# Rules
# A rule is a proc returning a plural type string based on the passed count
# Each plural rule may apply to many language/rule pairs below
rules = {
  zero_one_other: -> (count) {zero_one[count] || 'other'}
}

# Plurals (language/rule pairs)
# The default rule for missing languages is the :zero_one_other rule (used for English)
plurals = Hash.new(rules[:zero_one_other])

# Entries for all the languages defined in the pagy.yml dictionary
plurals['en'] = rules[:zero_one_other]

# PR for other languages are very welcome. Thanks!

# Return plurals
plurals
