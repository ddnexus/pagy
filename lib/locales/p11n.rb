# See https://ddnexus.github.io/pagy/api/frontend#i18n
# frozen_string_literal: true

# This file adds support for multiple built-in plualization types.
# It defines the pluralization procs and gets eval(ed) at I18N.load time.

# utility variables
zero_one   = ['zero', 'one'].freeze
from2to4   = (2..4).freeze
from5to9   = (5..9).freeze
from11to14 = (11..14).freeze
from12to14 = (12..14).freeze

# Pluralization (p11n)
# A pluralization proc returns a plural type string based on the passed count
# Each proc may apply to one or more locales below
p11n = {
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

# Hash of locale/pluralization pairs
# Contain all the entries for all the locales defined as dictionaries.
# The default pluralization for locales not explicitly listed here
# is the :zero_one_other pluralization proc (used for English)
Hash.new(p11n[:zero_one_other]).tap do |hash|
  hash['ru'] = p11n[:zero_one_few_many_other]
  hash['pl'] = p11n[:pl]
end

# PR for other locales and pluralizations are very welcome. Thanks!
