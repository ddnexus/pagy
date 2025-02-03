# frozen_string_literal: true

require 'yaml'
require_relative 'i18n/p11n'

class Pagy
  # Pagy i18n implementation, compatible with the I18n gem, just a lot faster and lighter
  module I18n
    extend self

    # rubocop:disable Style/MutableConstant
    PATHNAMES = [ROOT.join('locales')]
    # Stores the i18n DATA structure for each loaded locale
    DATA = {}
    # rubocop:enable Style/MutableConstant

    # Translate and pluralize the key with the locale DATA
    def translate(key, locale:, **options)
      data, p11n  = DATA[locale] || self.load(locale)
      translation = data[key] || (options[:count] && data[key += ".#{p11n.plural_for(options[:count])}"]) \
                      or return %([translation missing: "#{key}"])
      translation.gsub(/%{[^}]+?}/) { |match| options[:"#{match[2..-2]}"] || match }
    end

    private

    def load(locale)
      path = PATHNAMES.map { |p| p.join("#{locale}.yml") }.find(&:exist?)
      raise Errno::ENOENT, "missing dictionary file for #{locale.inspect} locale" unless path

      dictionary   = YAML.load_file(path)[locale]
      p11n         = dictionary['pagy'].delete('p11n')
      DATA[locale] = [flatten_to_dot_keys(dictionary), Object.const_get("Pagy::I18n::P11n::#{p11n}")]
    end

    # Create a flat hash with dotted notation keys
    def flatten_to_dot_keys(initial, prefix = '')
      initial.each.reduce({}) do |hash, (key, value)|
        hash.merge!(value.is_a?(Hash) ? flatten_to_dot_keys(value, "#{prefix}#{key}.") : { "#{prefix}#{key}" => value })
      end
    end
  end
end
