# frozen_string_literal: true

class Pagy
  module Frontend
    module Loader
      frontend_methods = { pagy_bootstrap_combo_nav_js: 'bootstrap/combo_nav_js',
                           pagy_bootstrap_nav:          'bootstrap/nav',
                           pagy_bootstrap_nav_js:       'bootstrap/nav_js',
                           pagy_bulma_combo_nav_js:     'bulma/combo_nav_js',
                           pagy_bulma_nav:              'bulma/nav',
                           pagy_bulma_nav_js:           'bulma/nav_js',
                           pagy_previous_anchor:        'pagy/anchors',
                           pagy_next_anchor:            'pagy/anchors',
                           pagy_combo_nav_js:           'pagy/combo_nav_js',
                           pagy_info:                   'pagy/info',
                           pagy_limit_selector_js:      'pagy/limit_selector',
                           pagy_previous_link:          'pagy/links',
                           pagy_next_link:              'pagy/links',
                           pagy_nav:                    'pagy/nav',
                           pagy_nav_js:                 'pagy/nav_js',
                           pagy_previous_url:           'pagy/urls',
                           pagy_next_url:               'pagy/urls' }.freeze

      define_method :pagy_load_frontend do |*args, **kwargs|
        method_sym = __callee__
        require_relative frontend_methods[method_sym]
        send(method_sym, *args, **kwargs)
      end

      frontend_methods.each_key do |method|
        class_eval "alias #{method} pagy_load_frontend", __FILE__, __LINE__ # alias pagy_* pagy_load_frontend
      end
    end
  end
end
