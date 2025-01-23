# frozen_string_literal: true

# Pagy initializer file (9.3.3)


###################################### DEFAULT #######################################
# Customizing the static and frozen Pagy::DEFAULT is NOT SUPPORTED anymore!
#
# As an alternative to avoid repetitions, define your own default hash and pass it
# to the different paginator methods.
# For example:
#
# PAGY_DEFAULT = { limit: 10 }.freeze
# pagy_offset(collection, **PAGY_DEFAULT, **other_vars)
# pagy_keyset(set, **PAGY_DEFAULT, **other_vars)

# Notice that it's just a hash that you can name and define how and where you prefer:
# just remember to pass it along when you need it.


#################################### IMPORTANT #######################################
# Do not configure anything below this line if you use only the :en locale


############# Pagy Translation Besides :en ###########################################
# Use the pagy internal I18n: ~18x faster using ~10x less memory than the i18n gem
# If you want to use the slower I18n gem, skip this and look at the end of this file.
#
# Examples (use only one statement):
#
# Load the "de" built-in locale:
# Pagy::I18n.load(locale: 'de')
#
# Load the "de" locale defined in the custom file at :filepath:
# Pagy::I18n.load(locale: 'de', filepath: 'path/to/pagy-de.yml')
#
# Load the "de", "en" and "es" built-in locales:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load({ locale: 'de' },
#                 { locale: 'en' },
#                 { locale: 'es' })
#
# Advanced usage:
# Load the "en" built-in locale, a custom "es" locale,
# and a totally custom locale complete with a custom :pluralize proc:
# (the first passed :locale will be used also as the default_locale)
# Pagy::I18n.load({ locale: 'en' },
#                 { locale: 'es', filepath: 'path/to/pagy-es.yml' },
#                 { locale: 'xyz',  # not built-in
#                   filepath: 'path/to/pagy-xyz.yml',
#                   pluralize: lambda{ |count| ... } )


############# I18n gem Translation Besides :en ######################################
# Uncomment the following line if you REALLY want to switch
# to the standard I18n gem translation:
#
# Pagy::Frontend.translate_with_the_slower_i18n_gem!


############# Calendar Localization Besides :en ######################################
# Add the list of locale symbols and comment the following line to enable it,
# regardless if you use the I18n gem for translations or not.
#
# Pagy::Offset::Calendar.localize_with_rails_i18n_gem(*your_locales)
