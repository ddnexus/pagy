# See https://ddnexus.github.io/pagy/api/frontend#i18n
# encoding: utf-8
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
  one_other: lambda {|n| n == 1 ? 'one' : 'other'},    # default

  east_slavic: lambda do |n|
    n ||= 0
    mod10 = n % 10
    mod100 = n % 100

    if    mod10 == 1 && mod100 != 11                                            ; 'one'
    elsif from2to4.include?(mod10) && !from12to14.include?(mod100)              ; 'few'
    elsif mod10 == 0 || from5to9.include?(mod10) || from11to14.include?(mod100) ; 'many'
    else                                                                          'other'
    end
  end,

  one_two_other: lambda do |n|
    if n == 1    ; 'one'
    elsif n == 2 ; 'two'
    else           'other'
    end
  end,

  one_upto_two_other: lambda {|n| n && n >= 0 && n < 2 ? 'one' : 'other'},

  other: Proc.new { 'other' },

  polish: lambda do |n|
    n ||= 0
    mod10 = n % 10
    mod100 = n % 100
    if n == 1                                                                  ; 'one'
    elsif from2to4.include?(mod10) && !from12to14.include?(mod100)             ; 'few'
    elsif (from0to1 + from5to9).include?(mod10) || from12to14.include?(mod100) ; 'many'
    else                                                                         'other'
    end
  end
}

# Hash of locale/pluralization pairs
# It contains all the entries for all the locales defined as dictionaries.
# The default pluralization for locales not explicitly listed here
# is the :one_other pluralization proc (used for English)
plurals = Hash.new(p11n[:one_other]).tap do |hash|
  hash['id'] = p11n[:other]
  hash['fr'] = p11n[:one_upto_two_other]
  hash['ja'] = p11n[:other]
  hash['pl'] = p11n[:polish]
  hash['ru'] = p11n[:east_slavic]
  hash['se'] = p11n[:one_two_other]
  hash['tr'] = p11n[:other]
  hash['zh-CN'] = p11n[:other]
  hash['zh-HK'] = p11n[:other]
  hash['zh-TW'] = p11n[:other]
end

[ plurals, p11n ]

# PR for other locales and pluralizations are very welcome. Thanks!
