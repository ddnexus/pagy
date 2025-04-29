# frozen_string_literal: true

# Pagy initializer file (10.0.0)
# See https://ddnexus.github.io/pagy/toolbox/initializer/

############ Global Options ################################################################
# Add your global options below. They will be applied globally.
# For example:
#
# Pagy.options[:limit] = 10               # Limit the items per page
# Pagy.options[:client_max_limit] = 100   # The client can request a limit up to 100
# Pagy.options[:max_pages] = 200          # Allow only 200 pages
# Pagy.options[:jsonapi] = true           # Use JSON:API compliant URLs


############ JavaScript ####################################################################
# See https://ddnexus.github.io/pagy/resources/javascript/ for further details.
# Examples for Rails:
# For apps with an assets pipeline
# Rails.application.config.assets.paths << Pagy::ROOT.join('javascript')
#
# For apps with a javascript builder (e.g. esbuild, webpack, etc.)
# javascript_dir = Rails.root.join('app/javascript')
# Pagy.sync_javascript(javascript_dir, 'pagy.mjs') if Rails.env.development?


############# Overriding Pagy::I18n Lookup #################################################
# Refer to https://ddnexus.github.io/pagy/resources/i18n/ for more information.
# Override the dictionary lookup for customization by dropping your customized
# Example for Rails:
#
# Pagy::I18n.pathnames << Rails.root.join('config/locales')


############# Calendar Localization for non-en locales ###########################
# Add your desired locales to the list and uncomment the following line to enable them,
# regardless of whether you use the I18n gem for translations or not, whether with
# Rails or not.
#
# Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)


############# I18n Gem Translation #########################################################
# See https://ddnexus.github.io/pagy/resources/i18n/
#
# Pagy.translate_with_the_slower_i18n_gem!
