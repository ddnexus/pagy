# This file adds support for multiple built-in plualization types.
# It defines the pluralization procs and gets eval(ed) at I18N.load time.
# frozen_string_literal: true

# utility variables
zero_one   = ['zero', 'one'].freeze
from2to4   = (2..4).freeze
from5to9   = (5..9).freeze
from11to14 = (11..14).freeze
from12to14 = (12..14).freeze

# Plurals
# A plural proc returns a plural type string based on the passed count
# Each plural proc may apply to one or more languages below
plurals = {
  zero_one_other: lambda {|count| zero_one[count] || 'other'},

  zero_one_few_many_other: lambda do |count|
    mod10, mod100 = count % 10, count % 100
    if count == 0                                                           ; 'zero'
    elsif mod10 == 1 && mod100 != 11                                        ; 'one'
    elsif from2to4.cover?(mod10) && !from12to14.cover?(mod100)              ; 'few'
    elsif mod10 == 0 || from5to9.cover?(mod10) || from11to14.cover?(mod100) ; 'many'
    else                                                                      'other'
    end
  end,

  pl: lambda do |count|
    mod10, mod100 = count % 10, count % 100
    if count == 0                                                                       ; 'zero'
    elsif count == 1                                                                    ; 'one'
    elsif from2to4.cover?(mod10) && !from12to14.cover?(mod100)                          ; 'few'
    elsif [0, 1].include?(mod10) || from5to9.cover?(mod10) || from12to14.cover?(mod100) ; 'many'
    else                                                                                  'other'
    end
  end
}

# Languages (language/plural pairs)
# Contain all the entries for all the languages defined in the dictionaries.
# The default plural for languages not explicitly listed here
# is the :zero_one_other plural (used for English)
Hash.new(plurals[:zero_one_other]).tap do |languages|
  languages['en'] = plurals[:zero_one_other]
  languages['ru'] = plurals[:zero_one_few_many_other]
  languages['pl'] = plurals[:pl]
end

# PR for other languages and plurals are very welcome. Thanks!
