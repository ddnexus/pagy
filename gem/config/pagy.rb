# frozen_string_literal: true

# Pagy initializer file (43.5.3)
# See https://ddnexus.github.io/pagy/toolbox/configuration/initializer/


############ Global Options ################################################################
# See https://ddnexus.github.io/pagy/toolbox/configuration/options/ for details.
# Examples:
#
# Pagy::OPTIONS[:limit]     = 10     # Limit the items per page
# Pagy::OPTIONS[:max_limit] = 100    # The client is allowed to request a limit up to 100
# Pagy::OPTIONS[:jsonapi]   = true   # Use JSON:API compliant URLs

Pagy::OPTIONS.freeze

############ JS and CSS Resources ##########################################################
# See https://ddnexus.github.io/pagy/resources/javascript/
# and https://ddnexus.github.io/pagy/resources/stylesheets/ for details.
# Sync example:
#
# if Rails.env.development?
#   Pagy.sync(:javascript, Rails.root.join('app/javascript'), 'pagy.mjs')
#   Pagy.sync(:stylesheet, Rails.root.join('app/stylesheets'), 'pagy.css')
# end
#
# Pipeline example:
#
# Rails.application.config.assets.paths << Pagy::ROOT.join(':javascripts')
# Rails.application.config.assets.paths << Pagy::ROOT.join(':stylesheets')

############# Overriding Pagy::I18n Lookup #################################################
# See https://ddnexus.github.io/pagy/resources/i18n/ for details.
# Example for Rails:
#
# Pagy::I18n.pathnames << Rails.root.join('config/locales/pagy')

############# I18n Gem Translation #########################################################
# See https://ddnexus.github.io/pagy/resources/i18n/ for details.
#
# Pagy.translate_with_the_slower_i18n_gem!

############# Calendar Localization for non-en locales ####################################
# See https://ddnexus.github.io/pagy/toolbox/paginators/calendar#localization for details.
#
# Pagy::Calendar.localize_with_rails_i18n_gem(*your_locales)
