# See https://ddnexus.github.io/pagy/api/frontend#i18n
# frozen_string_literal: true

# This file adds support for multiple built-in plualization types.
# It defines the pluralization procs and gets eval(ed) and gc-collected at Pagy::I18n.load time.

# utility variables
from0to1   = [0,1].freeze
from2to4   = [2,3,4].freeze
from5to9   = [5,6,7,8,9].freeze
from11to14 = [11,12,13,14].freeze
from12to14 = [12,13,14].freeze

# Pluralization (p11n)
# Compliant with the I18n gem
# A pluralization proc returns a plural type string based on the passed count
# Each proc may apply to one or more locales below.
# Pluralization logic adapted from https://github.com/svenfuchs/rails-i18n
p11n = {
  one_other: -> (n){ n == 1 ? 'one' : 'other' },    # default

  east_slavic: lambda do |n|
    n ||= 0
    mod10 = n % 10
    mod100 = n % 100

    case
    when mod10 == 1 && mod100 != 11                                            then 'one'
    when from2to4.include?(mod10) && !from12to14.include?(mod100)              then 'few'
    when mod10 == 0 || from5to9.include?(mod10) || from11to14.include?(mod100) then 'many' # rubocop:disable Style/NumericPredicate
    else                                                                            'other'
    end
  end,

  west_slavic: lambda do |n|
    case n
    when 1       then 'one'
    when 2, 3, 4 then 'few'
    else              'other'
    end
  end,

  one_two_other: lambda do |n|
    case n
    when 1 then 'one'
    when 2 then 'two'
    else        'other'
    end
  end,

  one_upto_two_other: -> (n){ n && n >= 0 && n < 2 ? 'one' : 'other' },

  other: -> (*){ 'other' },

  polish: lambda do |n|
    n ||= 0
    mod10  = n % 10
    mod100 = n % 100

    case
    when n == 1                                                               then 'one'
    when from2to4.include?(mod10) && !from12to14.include?(mod100)             then 'few'
    when (from0to1 + from5to9).include?(mod10) || from12to14.include?(mod100) then 'many'
    else                                                                           'other'
    end
  end
}

# Hash of locale/pluralization pairs
# It contains all the entries for all the locales defined as dictionaries.
# The default pluralization for locales not explicitly listed here
# is the :one_other pluralization proc (used for English)
plurals = Hash.new(p11n[:one_other]).tap do |hash|
  hash['bs']    = p11n[:east_slavic]
  hash['cs']    = p11n[:west_slavic]
  hash['id']    = p11n[:other]
  hash['fr']    = p11n[:one_upto_two_other]
  hash['hr']    = p11n[:east_slavic]
  hash['ja']    = p11n[:other]
  hash['km']    = p11n[:other]
  hash['ko']    = p11n[:other]
  hash['pl']    = p11n[:polish]
  hash['ru']    = p11n[:east_slavic]
  hash['sr']    = p11n[:east_slavic]
  hash['sv']    = p11n[:one_two_other]
  hash['sv-SE'] = p11n[:one_two_other]
  hash['tr']    = p11n[:other]
  hash['uk']    = p11n[:east_slavic]
  hash['zh-CN'] = p11n[:other]
  hash['zh-HK'] = p11n[:other]
  hash['zh-TW'] = p11n[:other]
end

[ plurals, p11n ]

# PR for other locales and pluralizations are very welcome. Thanks!
