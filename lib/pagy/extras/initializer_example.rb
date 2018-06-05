# Example of initializer file
# Customize only what you really need but notice that Pagy works also without any of the following lines.


# Extras
# See https://ddnexus.github.io/pagy/extras

# Array: Paginate arrays efficiently avoiding expensive array-wrapping and wihout overriding
# See https://ddnexus.github.io/pagy/extras/array
# require 'pagy/extras/array'

# Bootstrap: Nav helper and templates for Bootstrap pagination
# See https://ddnexus.github.io/pagy/extras/bootstrap
# require 'pagy/extras/bootstrap'

# Compact: An alternative UI that combines the pagination with the nav info in one compact element
# See https://ddnexus.github.io/pagy/extras/compact
# require 'pagy/extras/compact'

# I18n: Uses the `I18n` gem instead of the pagy implementation
# See https://ddnexus.github.io/pagy/extras/i18n
# require 'pagy/extras/i18n'

# Responsive: On resize, the number of page links will adapt in real-time to the available window or container width
# See https://ddnexus.github.io/pagy/extras/responsive
# require 'pagy/extras/responsive'


# Pagy Variables
# All the Pagy::VARS here are set for all the Pagy instances but can be
# overridden by just passing them to Pagy.new or the #pagy controller method

# Core variables (See https://ddnexus.github.io/pagy/api/pagy#core-variables)
# Pagy::VARS[:items] = 20                                   # default

# Non Core Variables (See https://ddnexus.github.io/pagy/api/pagy#non-core-variables)
# Pagy::VARS[:size]       = [1,4,4,1]                       # default
# Pagy::VARS[:page_param] = :page                           # default
# Pagy::VARS[:params]     = {}                              # default
# Pagy::VARS[:anchor]     = '#anchor'                       # example
# Pagy::VARS[:link_extra] = 'data-remote="true"'            # example
# Pagy::VARS[:item_path]  = 'activerecord.models.product'   # example

# Extras Non Core Variables
# See https://ddnexus.github.io/pagy/extras/responsive#breakpoints
# Pagy::VARS[:breakpoints] = { 0 => [1,2,2,1], 350 => [2,3,3,2], 550 => [3,4,4,3] }    # example of width/size pairs


# Pagy::Frontend::I18N Constant
# See https://ddnexus.github.io/pagy/api/frontend#i18n
# Pagy::Frontend::I18N[:plurals] = -> (c) {([:zero, :one][c] || :other).to_s   # default
# Pagy::Frontend::I18N.load_file('path/to/dictionary.yml')                     # load a custom file


# Rails: extras assets path required by compact or responsive extras
# See https://ddnexus.github.io/pagy/extras/compact and https://ddnexus.github.io/pagy/extras/responsive
# Rails.application.config.assets.paths << Pagy.root.join('pagy', 'extras', 'javascripts')
