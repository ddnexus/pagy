# frozen_string_literal: true

# Pagy initializer file (9.3.3)


############ Global Options #########################################################
# Add your global options here. They will get applied to all paginators.
# For example:
#
# Pagy.options[:limit] = 10               # Limit the items per page
# Pagy.options[:requestable_limit] = 100  # The client can request a limit up to 100
# Pagy.options[:max_pages] = 200          # Allow only 200 pages


############ Sync Javascript #########################################################
# IF:   Your code uses any pagy method ending with `_js`
# AND:  Your app use a javascript builder (e.g. esbuild, webpack, etc.)
# THEN: Sync 'pagy.mjs' at app startup in development environment:
# Example for Rails:
#
# javascript_dir = Rails.root.join('app/javascript')
# Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?


############# Overriding Pagy::I18n lookup ###########################################
# Override the dictionary lookup for customization. Just drop your customized
# dictionary/dictionaries in a dir and add its pathname to the I18n pathnames.
# Example for Rails:
#
# Pagy::I18n.pathnames << Rails.root.join('config/locales')


############# Calendar Localization Besides :en ######################################
# Add the list of your locales and uncomment the following line to enable it,
# regardless of whether you use the I18n gem for translations or not, whether with
# Rails or not.
#
# Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)


############# I18n gem translation ###################################################
# Uncomment the following line if you need to switch to the standard I18n gem:
#
# Pagy.translate_with_the_slower_i18n_gem!
