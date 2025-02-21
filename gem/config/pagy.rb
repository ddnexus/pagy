# frozen_string_literal: true

# Pagy initializer file (9.3.3)


################################## Global Options ####################################
# Pagy.options[:limit] = 10


############ Sync Pagy Javascript Source #############################################
# All the pagy method ending with '*_js', require syncing javascript source
# at app startup in development environment:

# Generic reference to customize
# Available source formats: pagy.mjs, pagy.js, pagy.js.map, pagy.min.js
# Pagy.sync_javascript_source(app_js_source_path, 'pagy.mjs', ...) if dev_env

# Example for Rails
# javascript_dir = Rails.root.join('app/javascript')
# Pagy.sync_javascript_source(javascript_dir, 'pagy.mjs') if Rails.env.development?


############# Overriding Pagy::I18n lookup ###########################################
# Override the dictionary lookup for customization. Just drop your customized
# dictionary/dictionaries in a dir and unshift its pathname to the PATHNAMES array.
# Example for Rails:
# Pagy::I18n.pathnames.unshift(Rails.root.join('config/locales'))


############# I18n gem translation ###################################################
# Uncomment the following line if you really have to switch
# to the standard I18n gem translation:
# Pagy.translate_with_the_slower_i18n_gem!


############# Calendar Localization Besides :en ######################################
# Add the list of your locales and uncomment the following line to enable it,
# regardless if you use the I18n gem for translations or not, Rails or not.
# Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)
