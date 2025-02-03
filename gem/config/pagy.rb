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


############ Install Pagy Javascript #####################################################
# If you use any pagy method ending with '*_js',
# uncomment/customize one of the following:

# Generic reference to customize
# Available file formats: 'pagy.mjs', 'pagy.js', 'pagy.js.map', 'pagy.min.js'
# Pagy::Javascript.install('pagy.mjs', 'pagy.js', ..., javascript_path) if env_dev

# Example for Rails
# javascript_path = Rails.root.join('app/javascript')
# Install all files...
# Pagy::Javascript.install(javascript_path)) if Rails.env.development?
# Install only 'pagy.mjs'...
# Pagy::Javascript.install('pagy.mjs', javascript_path) if Rails.env.development?


############# Overriding Pagy::I18n dictionary lookup ######################################
# Override the dictionary lookup for customization. Just drop your customized
# dictionary/dictionaries in a dir and add its pathname to the lookup:
# Pagy::I18n::PATHNAMES.unshift(Pathname.new('my/customized/dictionaries'))


############# I18n gem translation ######################################
# Uncomment the following line if you really have to switch
# to the standard I18n gem translation:
# Pagy::Frontend.translate_with_the_slower_i18n_gem!


############# Calendar Localization Besides :en ######################################
# Add the list of your locales and uncomment the following line to enable it,
# regardless if you use the I18n gem for translations or not, Rails or not.
# Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)
