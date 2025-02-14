# frozen_string_literal: true

class Pagy
  module Loader
    pagy_methods = { extract_hash:           'helpers/extract_hash',
                     headers_hash:           'helpers/headers_hash',
                     links_hash:             'helpers/links_hash',
                     bootstrap_combo_nav_js: 'components/bootstrap/combo_nav_js',
                     bootstrap_nav:          'components/bootstrap/nav',
                     bootstrap_nav_js:       'components/bootstrap/nav_js',
                     bulma_combo_nav_js:     'components/bulma/combo_nav_js',
                     bulma_nav:              'components/bulma/nav',
                     bulma_nav_js:           'components/bulma/nav_js',
                     previous_anchor:        'components/pagy/anchors',
                     next_anchor:            'components/pagy/anchors',
                     combo_nav_js:           'components/pagy/combo_nav_js',
                     info:                   'components/pagy/info',
                     limit_selector_js:      'components/pagy/limit_selector',
                     previous_link:          'components/pagy/links',
                     next_link:              'components/pagy/links',
                     nav:                    'components/pagy/nav',
                     nav_js:                 'components/pagy/nav_js',
                     previous_url:           'components/pagy/urls',
                     next_url:               'components/pagy/urls' }.freeze

    define_method :load_methods do |*args, **kwargs|
      method_sym = __callee__
      require_relative pagy_methods[method_sym]
      send(method_sym, *args, **kwargs)
    end

    pagy_methods.each_key do |method|
      class_eval "alias #{method} load_methods", __FILE__, __LINE__ # alias * load_method
    end
  end
end
