# See https://ddnexus.github.io/pagy/api/frontend#i18n
# encoding: utf-8
# frozen_string_literal: true

# this file returns the I18n hash used as default alternative to the i18n gem

Hash.new{|h,_| h.first[1]}.tap do |i18n|   # first loaded locale used as default
  i18n.define_singleton_method(:load) do |*args|
    # eval: we don't need to keep the loader proc in memory
    eval(Pagy.root.join('locales', 'utils', 'loader.rb').read).call(i18n, *args)   #rubocop:disable Security/Eval
  end
  i18n.define_singleton_method(:t) do |locale, path, vars={}|
    data, pluralize = self[locale]
    translate = data[path] || vars[:count] && data[path+=".#{pluralize.call(vars[:count])}"] or return %([translation missing: "#{path}"])
    translate.call(vars)
  end
  i18n.load(locale: 'en')
end
