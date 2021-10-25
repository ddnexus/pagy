# See Pagy::I18n API documentation https://ddnexus.github.io/pagy/api/i18n
# frozen_string_literal: true

require 'yaml'

class Pagy
  # Pagy i18n implementation, compatible with the I18n gem, just a lot faster and lighter
  module I18n
    extend self

    # Pluralization rules
    module P11n
      # Utility variables
      from0to1   = [0, 1].freeze
      from2to4   = [2, 3, 4].freeze
      from5to9   = [5, 6, 7, 8, 9].freeze
      from11to14 = [11, 12, 13, 14].freeze
      from12to14 = [12, 13, 14].freeze

      # Store the proc defining each pluralization RULE
      # Logic adapted from https://github.com/svenfuchs/rails-i18n
      RULE = {
        arabic:
          lambda do |n = 0|
            mod100 = n % 100
            case
            when n == 0                         then 'zero' # rubocop:disable Style/NumericPredicate
            when n == 1                         then 'one'
            when n == 2                         then 'two'
            when (3..10).to_a.include?(mod100)  then 'few'
            when (11..99).to_a.include?(mod100) then 'many'
            else                                     'other'
            end
          end,

        east_slavic:
          lambda do |n = 0|
            mod10  = n % 10
            mod100 = n % 100
            case
            when mod10 == 1 && mod100 != 11                                            then 'one'
            when from2to4.include?(mod10) && !from12to14.include?(mod100)              then 'few'
            when mod10 == 0 || from5to9.include?(mod10) || from11to14.include?(mod100) then 'many' # rubocop:disable Style/NumericPredicate
            else                                                                            'other'
            end
          end,

        one_other:
          ->(n) { n == 1 ? 'one' : 'other' }, # default RULE

        one_two_other:
          lambda do |n|
            case n
            when 1 then 'one'
            when 2 then 'two'
            else        'other'
            end
          end,

        one_upto_two_other:
          ->(n) { n && n >= 0 && n < 2 ? 'one' : 'other' },

        other:
          ->(*) { 'other' },

        polish:
          lambda do |n = 0|
            mod10  = n % 10
            mod100 = n % 100
            case
            when n == 1                                                               then 'one'
            when from2to4.include?(mod10) && !from12to14.include?(mod100)             then 'few'
            when (from0to1 + from5to9).include?(mod10) || from12to14.include?(mod100) then 'many'
            else                                                                           'other'
            end
          end,

        west_slavic:
          lambda do |n|
            case n
            when 1         then 'one'
            when *from2to4 then 'few'
            else                'other'
            end
          end

      }.freeze

      # Store the RULE to apply to each LOCALE
      # the :one_other RULE is the default for locales missing from this list
      LOCALE = Hash.new(RULE[:one_other]).tap do |hash|
                 hash['ar']    = RULE[:arabic]
                 hash['bs']    = RULE[:east_slavic]
                 hash['cs']    = RULE[:west_slavic]
                 hash['id']    = RULE[:other]
                 hash['fr']    = RULE[:one_upto_two_other]
                 hash['hr']    = RULE[:east_slavic]
                 hash['ja']    = RULE[:other]
                 hash['km']    = RULE[:other]
                 hash['ko']    = RULE[:other]
                 hash['pl']    = RULE[:polish]
                 hash['ru']    = RULE[:east_slavic]
                 hash['sr']    = RULE[:east_slavic]
                 hash['sv']    = RULE[:one_two_other]
                 hash['sv-SE'] = RULE[:one_two_other]
                 hash['tr']    = RULE[:other]
                 hash['uk']    = RULE[:east_slavic]
                 hash['zh-CN'] = RULE[:other]
                 hash['zh-HK'] = RULE[:other]
                 hash['zh-TW'] = RULE[:other]
               end.freeze
    end

    # Stores the i18n DATA structure for each loaded locale
    # default on the first locale DATA
    DATA = Hash.new { |hash, _| hash.first[1] }

    private

    # Create a flat hash with dotted notation keys
    def flatten(initial, prefix = '')
      initial.each.reduce({}) do |hash, (key, value)|
        hash.merge!(value.is_a?(Hash) ? flatten(value, "#{prefix}#{key}.") : { "#{prefix}#{key}" => value })
      end
    end

    # Build the DATA hash out of the passed locales
    def build(*locales)
      locales.each do |locale|
        locale[:filepath]  ||= Pagy.root.join('locales', "#{locale[:locale]}.yml")
        locale[:pluralize] ||= P11n::LOCALE[locale[:locale]]
        dictionary = YAML.safe_load(File.read(locale[:filepath], encoding: 'UTF-8'))
        raise I18nError, %(expected :locale "#{locale[:locale]}" not found in :filepath "#{locale[:filepath].inspect}") \
              unless dictionary.key?(locale[:locale])

        DATA[locale[:locale]] = [flatten(dictionary[locale[:locale]]), locale[:pluralize]]
      end
    end
    # Build the default at require time
    build(locale: 'en')

    public

    # Public method to configure the locales: overrides the default, build the DATA and freezes it
    def load(*locales)
      DATA.clear
      build(*locales)
      DATA.freeze
    end

    # Translate and pluralize the key with the locale DATA
    def t(locale, key, **opts)
      data, pluralize = DATA[locale]
      translation = data[key] || (opts[:count] && data[key += ".#{pluralize.call(opts[:count])}"]) \
                      or return %([translation missing: "#{key}"])
      translation.gsub(/%{[^}]+?}/) { |match| opts[:"#{match[2..-2]}"] || match }
    end
  end
end
