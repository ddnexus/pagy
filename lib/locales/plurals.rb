# This file adds support for multiple built-in plualization types.
# It defines the pluralization procs and gets eval(ed) at I18N.load time.
# frozen_string_literal: true

# utility variables
zero_one   = ['zero', 'one']
from2to4   = (2..4)
from5to9   = (5..9)
from11to14 = (11..14)
from12to14 = (12..14)

# Plurals
# A plural proc returns a plural type string based on the passed count
# Each plural proc may apply to one or more languages below
plurals = {
  zero_one_other:     -> (count) {zero_one[count] || 'other'},
  one_few_many_other: -> (count) do
    mod10, mod100 = count % 10, count % 100
    if    mod10 == 1 && mod100 != 11                                        ; 'one'
    elsif from2to4.cover?(mod10) && !from12to14.cover?(mod100)              ; 'few'
    elsif mod10 == 0 || from5to9.cover?(mod10) || from11to14.cover?(mod100) ; 'many'
    else                                                                      'other'
    end
  end
}

# Languages (language/plural pairs)
# Contain all the entries for all the languages defined in the dictionaries.
# The default plural for languages not explicitly listed here
# is the :zero_one_other plural (used for English)
Hash.new(plurals[:zero_one_other]).tap do |languages|
  languages['en'] = plurals[:zero_one_other]
  languages['ru'] = plurals[:one_few_many_other]
end

# PR for other languages and plurals are very welcome. Thanks!
