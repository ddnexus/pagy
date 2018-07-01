# This file adds support for multiple built-in plualization types.
# It defines the pluralization procs and gets eval(ed) at I18N.load time.
# frozen_string_literal: true

# utility variables
zero_one = ['zero', 'one']

# Plurals
# A plural proc returns a plural type string based on the passed count
# Each plural proc may apply to one or more languages below
plurals = {
  zero_one_other: -> (count) {zero_one[count] || 'other'}
}

# Languages (language/plural pairs)
# Contain all the entries for all the languages defined in the pagy.yml dictionary
# The default plural for missing languages is the :zero_one_other plural (used for English)
Hash.new(plurals[:zero_one_other]).tap do |languages|
  languages['en'] = plurals[:zero_one_other]

  # PR for other languages and plurals are very welcome. Thanks!

end
