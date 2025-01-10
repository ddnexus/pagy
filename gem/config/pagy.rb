# frozen_string_literal: true

# Pagy initializer file (9.3.3)

# Extras
# See https://ddnexus.github.io/pagy/categories/extra

# Size extra: Enable the Array type for the `:size` variable (e.g. `size: [1,4,4,1]`)
# See https://ddnexus.github.io/pagy/docs/extras/size
# require 'pagy/extras/size'   # must be required before the other extras

# Gearbox extra: Automatically change the limit per page depending on the page number
# See https://ddnexus.github.io/pagy/docs/extras/gearbox
# require 'pagy/extras/gearbox'
# set to false only if you want to make :gearbox_extra an opt-in variable
# Pagy::DEFAULT[:gearbox_extra] = false               # default true
# Pagy::DEFAULT[:gearbox_limit] = [15, 30, 60, 100]   # default

# Limit extra: Allow the client to request a custom limit per page with an optional selector UI
# See https://ddnexus.github.io/pagy/docs/extras/limit
# require 'pagy/extras/limit'
# set to false only if you want to make :limit_extra an opt-in variable
# Pagy::DEFAULT[:limit_extra] = false    # default true
# Pagy::DEFAULT[:limit_sym]   = :limit   # default
# Pagy::DEFAULT[:limit_max]   = 100      # default

# Jsonapi extra: Implements JSON:API specifications
# See https://ddnexus.github.io/pagy/docs/extras/jsonapi
# require 'pagy/extras/jsonapi'   # must be required after the other extras
# set to false only if you want to make :jsonapi an opt-in variable
# Pagy::DEFAULT[:jsonapi] = false  # default true

# I18n extra: uses the standard i18n gem which is ~18x slower using ~10x more memory
# than the default pagy internal i18n (see below)
# See https://ddnexus.github.io/pagy/docs/extras/i18n
# require 'pagy/extras/i18n'

# Pagy internal I18n: ~18x faster using ~10x less memory than the i18n gem
# See https://ddnexus.github.io/pagy/docs/api/i18n
# Notice: No need to configure anything in this section if your app uses only "en"
# or if you use the i18n extra below
#
# Examples:
# load the "de" built-in locale:
# Pagy::I18n.load(locale: 'de')
#
# load the "de" locale defined in the custom file at :filepath:
# Pagy::I18n.load(locale: 'de', filepath: 'path/to/pagy-de.yml')
#
# load the "de", "en" and "es" built-in locales:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load({ locale: 'de' },
#                 { locale: 'en' },
#                 { locale: 'es' })
#
# load the "en" built-in locale, a custom "es" locale,
# and a totally custom locale complete with a custom :pluralize proc:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load({ locale: 'en' },
#                 { locale: 'es', filepath: 'path/to/pagy-es.yml' },
#                 { locale: 'xyz',  # not built-in
#                   filepath: 'path/to/pagy-xyz.yml',
#                   pluralize: lambda{ |count| ... } )
