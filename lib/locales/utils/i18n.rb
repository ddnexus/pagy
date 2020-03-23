# See https://ddnexus.github.io/pagy/api/frontend#i18n
# encoding: utf-8
# frozen_string_literal: true

# this file returns the I18n hash used as default alternative to the i18n gem

Pagy::DEPRECATED_LOCALES = {'pt-br' =>'pt-BR', 'se' => 'sv-SE'}

Hash.new{|h,_| h.first[1]}.tap do |i18n_hash|   # first loaded locale used as default
  i18n_hash.define_singleton_method(:load) do |*load_args|
    # eval: we don't need to keep the loader proc in memory
    eval(Pagy.root.join('locales', 'utils', 'loader.rb').read).call(i18n_hash, *load_args)   #rubocop:disable Security/Eval
  end
  i18n_hash.define_singleton_method(:t) do |locale, path, vars={}|
    if Pagy::DEPRECATED_LOCALES.key?(locale)
      new_locale = Pagy::DEPRECATED_LOCALES[locale]
      $stderr.puts("WARNING: the Pagy locale '#{locale}' is deprecated; use '#{new_locale}' instead")
      locale = new_locale
    end
    data, pluralize = self[locale]
    translate = data[path] || vars[:count] && data[path+=".#{pluralize.call(vars[:count])}"] or return %([translation missing: "#{path}"])
    translate.call(vars)
  end
  i18n_hash.load(locale: 'en')
end
