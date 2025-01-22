# frozen_string_literal: true

# Pagy initializer file (9.3.3)

##### Pagy::DEFAULT #######################

# Customizing the static and frozen Pagy::DEFAULT is NOT SUPPORTED since version 10.0.0.
# Pass the variables to the constructor, or pass your own PAGY_DEFAULT hash.
# For example:
#
# PAGY_DEFAULT = { ... }
# pagy_offset(collection, **PAGY_DEFAULT, ...)


##### Extras #######################

# The extras are almost all converted to autoloaded mixins, or integrated in the core code at zero-cost.
# You can use the methods that you need, and they will just work without the need of any explicit `require`.
#
# The only extras that are left (for different compelling reasons) are listed below:
# gearbox, i18n and size. They must be required in the initializer as usual.


# Gearbox extra: Automatically change the limit per page depending on the page number
# (e.g. `gearbox_limit: [15, 30, 60, 100]`
# See https://ddnexus.github.io/pagy/docs/extras/gearbox
# require 'pagy/extras/gearbox'


# I18n extra: uses the standard i18n gem which is ~18x slower using ~10x more memory
# than the default pagy internal i18n (see below)
# See https://ddnexus.github.io/pagy/docs/extras/i18n
# require 'pagy/extras/i18n'


# Size extra: Enable the Array type for the `:size` variable (e.g. `size: [1,4,4,1]`)
# See https://ddnexus.github.io/pagy/docs/extras/size
# require 'pagy/extras/size'   # must be required before the other extras


##### Pagy::I18n configuration #######################

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
