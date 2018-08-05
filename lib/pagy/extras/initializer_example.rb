# Example of initializer file
# Customize only what you really need but notice that Pagy works also without any of the following lines.


# Extras
# See https://ddnexus.github.io/pagy/extras


# Component Extras

# Compact: An alternative UI that combines the pagination with the nav info in one compact element
# See https://ddnexus.github.io/pagy/extras/compact
# require 'pagy/extras/compact'

# Responsive: On resize, the number of page links will adapt in real-time to the available window/container width
# See https://ddnexus.github.io/pagy/extras/responsive
# require 'pagy/extras/responsive'
# See https://ddnexus.github.io/pagy/extras/responsive#breakpoints
# Pagy::VARS[:breakpoints] = { 0 => [1,2,2,1], 350 => [2,3,3,2], 550 => [3,4,4,3] }    # example of width/size pairs


# Backend Extras

# Array: Paginate arrays efficiently, avoiding expensive array-wrapping and without overriding
# See https://ddnexus.github.io/pagy/extras/array
# require 'pagy/extras/array'

# Searchkick: Paginate `Searchkick::Results` objects efficiently, avoiding expensive oject-wrapping and without overriding.
# See https://ddnexus.github.io/pagy/extras/searchkick
# require 'pagy/extras/searchkick'


# Frontend Extras

# Bootstrap: Nav helper and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/extras/bootstrap
# require 'pagy/extras/bootstrap'

# Bulma: Nav helper and templates for Bulma pagination
# See https://ddnexus.github.io/pagy/extras/bulma
# require 'pagy/extras/bulma'

# Materialize: Nav helper for Materialize pagination
# See https://ddnexus.github.io/pagy/extras/materialize
# require 'pagy/extras/materialize'


# Feature Extras

# Items: Allow the client to request a custom number of items per page with a ready to use selector UI
# See https://ddnexus.github.io/pagy/extras/items
# require 'pagy/extras/items'
# Pagy::VARS[:items_param] = :items    # default
# Pagy::VARS[:max_items]   = 100       # default

# Out Of Range: Allow for easy handling of out of range pages
# See https://ddnexus.github.io/pagy/extras/out_of_range
# Pagy::VARS[:out_of_range_mode] = :last_page    # default  (other options: :empty_page and :exception)

# Trim: Remove the page=1 param from links
# See https://ddnexus.github.io/pagy/extras/trim
# require 'pagy/extras/trim'



# Pagy Variables
# See https://ddnexus.github.io/pagy/api/pagy#variables
# All the Pagy::VARS are set for all the Pagy instances but can be overridden
# per instance by just passing them to Pagy.new or the #pagy controller method


# Instance variables
# See https://ddnexus.github.io/pagy/api/pagy#instance-variables
# Pagy::VARS[:items] = 20                                   # default


# Other Variables
# See https://ddnexus.github.io/pagy/api/pagy#other-variables
# Pagy::VARS[:size]       = [1,4,4,1]                       # default
# Pagy::VARS[:page_param] = :page                           # default
# Pagy::VARS[:params]     = {}                              # default
# Pagy::VARS[:anchor]     = '#anchor'                       # example
# Pagy::VARS[:link_extra] = 'data-remote="true"'            # example
# Pagy::VARS[:item_path]  = 'activerecord.models.product'   # example


# Rails

# Rails: extras assets path required by compact, items and responsive extras
# See https://ddnexus.github.io/pagy/extras
# Rails.application.config.assets.paths << Pagy.root.join('pagy', 'extras', 'javascripts')


# I18n

# I18n: faster internal pagy implementation (does not use the I18n gem)
# Use only for single language apps that don't need dynamic translation between multiple languages
# See https://ddnexus.github.io/pagy/api/frontend#i18n
# Notice: Do not use the following 2 lines if you use the i18n extra below
# Pagy::Frontend::I18N.load(file:'path/to/dictionary.yml', language:'en')            # load a custom file
# Pagy::Frontend::I18N[:plural] = -> (count) {(['zero', 'one'][count] || 'other')}   # default

# I18n: Use the `I18n` gem instead of the pagy implementation
# (slower but allows dynamic translation between multiple languages)
# See https://ddnexus.github.io/pagy/extras/i18n
# require 'pagy/extras/i18n'
