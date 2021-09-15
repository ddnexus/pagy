# See https://ddnexus.github.io/pagy/api/frontend#i18n
# frozen_string_literal: true

# this file returns the I18n hash used as default alternative to the i18n gem

Hash.new { |h, _| h.first[1] }.tap do |i18n_hash| # first loaded locale used as default
  i18n_hash.define_singleton_method(:load) do |*load_args|
    # eval: we don't need to keep the loader proc in memory
    eval(Pagy.root.join('locales', 'utils', 'loader.rb').read).call(i18n_hash, *load_args)   # rubocop:disable Security/Eval
  end
  i18n_hash.define_singleton_method(:t) do |locale, key, **opts|
    data, pluralize = self[locale]
    translate = data[key] || (opts[:count] && data[key += ".#{pluralize.call(opts[:count])}"]) or return %([translation missing: "#{key}"])
    translate.call(opts)
  end
  i18n_hash.load(locale: 'en')
end
