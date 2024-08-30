# frozen_string_literal: true

# Pagy initializer file (9.0.7)
# Customize only what you really need and notice that the core Pagy works also without any of the following lines.
# Should you just cherry pick part of this file, please maintain the require-order of the extras


# Pagy Variables
# See https://ddnexus.github.io/pagy/docs/api/pagy#variables
# You can set any pagy variable as a Pagy::DEFAULT. They can also be overridden per instance by just passing them to
# Pagy.new|Pagy::Countless.new|Pagy::Calendar::*.new or any of the #pagy* controller methods
# Here are the few that make more sense as DEFAULTs:
# Pagy::DEFAULT[:limit]       = 20                    # default
# Pagy::DEFAULT[:size]        = 7                     # default
# Pagy::DEFAULT[:ends]        = true                  # default
# Pagy::DEFAULT[:page_param]  = :page                 # default
# Pagy::DEFAULT[:count_args]  = []                    # example for non AR ORMs
# Pagy::DEFAULT[:max_pages]   = 3000                  # example


# Extras
# See https://ddnexus.github.io/pagy/categories/extra


# Legacy Compatibility Extras

# Size extra: Enable the Array type for the `:size` variable (e.g. `size: [1,4,4,1]`)
# See https://ddnexus.github.io/pagy/docs/extras/size
# require 'pagy/extras/size'   # must be required before the other extras


# Backend Extras

# Arel extra: For better performance utilizing grouped ActiveRecord collections:
# See: https://ddnexus.github.io/pagy/docs/extras/arel
# require 'pagy/extras/arel'

# Array extra: Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
# See https://ddnexus.github.io/pagy/docs/extras/array
# require 'pagy/extras/array'

# Calendar extra: Add pagination filtering by calendar time unit (year, quarter, month, week, day)
# See https://ddnexus.github.io/pagy/docs/extras/calendar
# require 'pagy/extras/calendar'
# Default for each calendar unit class in IRB:
# >> Pagy::Calendar::Year::DEFAULT
# >> Pagy::Calendar::Quarter::DEFAULT
# >> Pagy::Calendar::Month::DEFAULT
# >> Pagy::Calendar::Week::DEFAULT
# >> Pagy::Calendar::Day::DEFAULT
#
# Uncomment the following lines, if you need calendar localization without using the I18n extra
# module LocalizePagyCalendar
#   def localize(time, opts)
#     ::I18n.l(time, **opts)
#   end
# end
# Pagy::Calendar.prepend LocalizePagyCalendar

# Countless extra: Paginate without any count, saving one query per rendering
# See https://ddnexus.github.io/pagy/docs/extras/countless
# require 'pagy/extras/countless'
# Pagy::DEFAULT[:countless_minimal] = false   # default (eager loading)

# Elasticsearch Rails extra: Paginate `ElasticsearchRails::Results` objects
# See https://ddnexus.github.io/pagy/docs/extras/elasticsearch_rails
# Default :pagy_search method: change only if you use also
# the searchkick or meilisearch extra that defines the same
# Pagy::DEFAULT[:elasticsearch_rails_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy::DEFAULT[:elasticsearch_rails_search] = :search
# require 'pagy/extras/elasticsearch_rails'

# Headers extra: http response headers (and other helpers) useful for API pagination
# See http://ddnexus.github.io/pagy/extras/headers
# require 'pagy/extras/headers'
# Pagy::DEFAULT[:headers] = { page: 'Current-Page',
#                            limit: 'Page-Items',
#                            count: 'Total-Count',
#                            pages: 'Total-Pages' }     # default

# Keyset extra: Paginate with the Pagy keyset pagination technique
# See http://ddnexus.github.io/pagy/extras/keyset
# require 'pagy/extras/keyset'

# Meilisearch extra: Paginate `Meilisearch` result objects
# See https://ddnexus.github.io/pagy/docs/extras/meilisearch
# Default :pagy_search method: change only if you use also
# the elasticsearch_rails or searchkick extra that define the same method
# Pagy::DEFAULT[:meilisearch_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy::DEFAULT[:meilisearch_search] = :ms_search
# require 'pagy/extras/meilisearch'

# Metadata extra: Provides the pagination metadata to Javascript frameworks like Vue.js, react.js, etc.
# See https://ddnexus.github.io/pagy/docs/extras/metadata
# you must require the JS Tools internal extra (BEFORE the metadata extra) ONLY if you need also the :sequels
# require 'pagy/extras/js_tools'
# require 'pagy/extras/metadata'
# For performance reasons, you should explicitly set ONLY the metadata you use in the frontend
# Pagy::DEFAULT[:metadata] = %i[scaffold_url page prev next last]   # example

# Searchkick extra: Paginate `Searchkick::Results` objects
# See https://ddnexus.github.io/pagy/docs/extras/searchkick
# Default :pagy_search method: change only if you use also
# the elasticsearch_rails or meilisearch extra that defines the same
# DEFAULT[:searchkick_pagy_search] = :pagy_search
# Default original :search method called internally to do the actual search
# Pagy::DEFAULT[:searchkick_search] = :search
# require 'pagy/extras/searchkick'
# uncomment if you are going to use Searchkick.pagy_search
# Searchkick.extend Pagy::Searchkick


# Frontend Extras

# Bootstrap extra: Add nav, nav_js and combo_nav_js helpers and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/docs/extras/bootstrap
# require 'pagy/extras/bootstrap'

# Bulma extra: Add nav, nav_js and combo_nav_js helpers and templates for Bulma pagination
# See https://ddnexus.github.io/pagy/docs/extras/bulma
# require 'pagy/extras/bulma'

# Pagy extra: Add the pagy styled versions of the javascript-powered navs
# and a few other components to the Pagy::Frontend module.
# See https://ddnexus.github.io/pagy/docs/extras/pagy
# require 'pagy/extras/pagy'

# Multi size var used by the *_nav_js helpers
# See https://ddnexus.github.io/pagy/docs/extras/pagy#steps
# Pagy::DEFAULT[:steps] = { 0 => 5, 540 => 7, 720 => 9 }   # example


# Feature Extras

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
# Pagy::DEFAULT[:limit_param] = :limit   # default
# Pagy::DEFAULT[:limit_max]   = 100      # default

# Overflow extra: Allow for easy handling of overflowing pages
# See https://ddnexus.github.io/pagy/docs/extras/overflow
# require 'pagy/extras/overflow'
# Pagy::DEFAULT[:overflow] = :empty_page    # default  (other options: :last_page and :exception)

# Trim extra: Remove the page=1 param from links
# See https://ddnexus.github.io/pagy/docs/extras/trim
# require 'pagy/extras/trim'
# set to false only if you want to make :trim_extra an opt-in variable
# Pagy::DEFAULT[:trim_extra] = false # default true

# Standalone extra: Use pagy in non Rack environment/gem
# See https://ddnexus.github.io/pagy/docs/extras/standalone
# require 'pagy/extras/standalone'
# Pagy::DEFAULT[:url] = 'http://www.example.com/subdir'  # optional default

# Jsonapi extra: Implements JSON:API specifications
# See https://ddnexus.github.io/pagy/docs/extras/jsonapi
# require 'pagy/extras/jsonapi'   # must be required after the other extras
# set to false only if you want to make :jsonapi an opt-in variable
# Pagy::DEFAULT[:jsonapi] = false  # default true

# Rails
# Enable the .js file required by the helpers that use javascript
# (pagy*_nav_js, pagy*_combo_nav_js, and pagy_limit_selector_js)
# See https://ddnexus.github.io/pagy/docs/api/javascript

# With the asset pipeline
# Sprockets need to look into the pagy javascripts dir, so add it to the assets paths
# Rails.application.config.assets.paths << Pagy.root.join('javascripts')

# I18n

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


# I18n extra: uses the standard i18n gem which is ~18x slower using ~10x more memory
# than the default pagy internal i18n (see above)
# See https://ddnexus.github.io/pagy/docs/extras/i18n
# require 'pagy/extras/i18n'


# When you are done setting your own default freeze it, so it will not get changed accidentally
Pagy::DEFAULT.freeze
