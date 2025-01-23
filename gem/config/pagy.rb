# frozen_string_literal: true

# Pagy initializer file (9.3.3)


################################ Pagy::DEFAULT #################################
# Customizing the static and frozen Pagy::DEFAULT is NOT SUPPORTED anymore!
# Pass the variables to the paginator method, or pass your own PAGY_DEFAULT hash.
# For example:
#
# PAGY_DEFAULT = { limit: 10 }
# pagy_offset(collection, **PAGY_DEFAULT, **other_vars)


########## Extras ##############################################################
# Gearbox extra: Automatically change the limit depending on the page number
# See https://ddnexus.github.io/pagy/docs/extras/gearbox
# require 'pagy/extras/gearbox'
# Then pass e.g.: `gearbox_limit: [15, 30, 60, 100]` to the paginator method to activate the feature

# Size extra: Enable the legacy deprecated Array type for the `:size` variable (e.g. `size: [1,4,4,1]`)
# See https://ddnexus.github.io/pagy/docs/extras/size
# require 'pagy/extras/size'





################################# IMPORTANT ####################################
# Do not configure anything below this line if you use only the :en locale


########## Pagy Translation Besides :en ########################################
# Use the pagy internal I18n: ~18x faster using ~10x less memory than the i18n gem
# If you want to use the slower I18n gem, skip this and look at the end of this file.
#
# Examples (use only one statement):
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


########## I18n gem Translation Besides :en ###################################
# Uncomment the following line if you REALLY want to switch
# to the standard I18n gem translation:
#
# Pagy.translate_with_the_slower_i18n_gem!


########## Calendar Localization Besides :en ###################################
# The calendar localization data beside :en (which is included), is provided
# by the rails-i18n gem, which should be requested/added by your Gemfile.
# Add the list of locale symbols and comment the following line to enable it,
# regardless if you use the I18n gem for translations or not.
#
# Pagy::Offset::Calendar.localize_with_rails_i18n_gem(*your_locales)
