# frozen_string_literal: true

require 'yaml'
require_relative 'p11n'

class Pagy
  # Pagy i18n implementation, compatible with the I18n gem, just a lot faster and lighter
  module I18n
    extend self

    def pathnames
      @pathnames ||= [ROOT.join('locales')]
    end

    def locales
      @locales   ||= {}
    end

    # Store the variable for the duration of a single request
    def locale=(value)
      Thread.current[:pagy_locale] = value
    end

    def locale
      Thread.current[:pagy_locale] || 'en'
    end

    # Translate and pluralize the key with the locale entries
    def translate(key, **options)
      data, p11n  = locales[locale] || self.load
      translation = data[key] || (options[:count] && data[key += ".#{p11n.plural_for(options[:count])}"]) \
                      or return %([translation missing: "#{key}"])
      translation.gsub(/%{[^}]+?}/) { |match| options[:"#{match[2..-2]}"] || match }
    end

    private

    def load
      path = pathnames.reverse.map { |p| p.join("#{locale}.yml") }.find(&:exist?)
      raise Errno::ENOENT, "missing dictionary file for #{locale.inspect} locale" unless path

      dictionary      = YAML.load_file(path)[locale]
      p11n            = dictionary['pagy'].delete('p11n')
      locales[locale] = [flatten_to_dot_keys(dictionary), Object.const_get("Pagy::I18n::P11n::#{p11n}")]
    end

    # Create a flat hash with dotted notation keys
    # e.g. { 'a' => { 'b' => {'c' => 3, 'd' => 4 }}} -> { 'a.b.c' => 3, 'a.b.d' => 4 }
    def flatten_to_dot_keys(initial, prefix = '')
      initial.reduce({}) do |hash, (key, value)|
        hash.merge!(value.is_a?(Hash) ? flatten_to_dot_keys(value, "#{prefix}#{key}.") : { "#{prefix}#{key}" => value })
      end
    end
  end
end
