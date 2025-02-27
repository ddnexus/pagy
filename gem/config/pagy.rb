# frozen_string_literal: true

# Pagy initializer file (9.3.3)
# See https://ddnexus.github.io/pagy/toolbox/initializer/

############ Global Options #########################################################
# Add your global options here. They will get applied to all the @pagy instances.
# For example:
#
# Pagy.options[:limit] = 10               # Limit the items per page
# Pagy.options[:requestable_limit] = 100  # The client can request a limit up to 100
# Pagy.options[:max_pages] = 200          # Allow only 200 pages
# Pagy.options[:jsonapi] = true           # Use JSON:API compilant params and URLs


############ Sync Javascript #########################################################
# See https://ddnexus.github.io/pagy/resources/javascript/
# Examples for Rails:
# For apps with an assets pipeline
# Rails.application.config.assets.paths << Pagy::ROOT.join('javascript')
#
# For apps with a javascript builder (e.g. esbuild, webpack, etc.)
# javascript_dir = Rails.root.join('app/javascript')
# Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?


############# Overriding Pagy::I18n lookup ###########################################
# See https://ddnexus.github.io/pagy/resources/i18n/
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
# See https://ddnexus.github.io/pagy/resources/i18n/
#
# Pagy.translate_with_the_slower_i18n_gem!
