# frozen_string_literal: true

class Pagy
  module Frontend
    module Loader
      def pagy_load_frontend(...)
        method_sym = __callee__
        require FRONTEND_METHODS[method_sym]
        send(method_sym, ...)
      end

      path = ROOT.join('lib/pagy/frontend').freeze
      FRONTEND_METHODS = { pagy_bootstrap_nav:          path.join('bootstrap/nav'),
                           pagy_bootstrap_nav_js:       path.join('bootstrap/nav_js'),
                           pagy_bootstrap_combo_nav_js: path.join('bootstrap/combo_nav_js'),
                           pagy_bulma_nav:              path.join('bulma/nav'),
                           pagy_bulma_nav_js:           path.join('bulma/nav_js'),
                           pagy_bulma_combo_nav_js:     path.join('bulma/combo_nav_js'),
                           pagy_nav:                    path.join('pagy/nav'),
                           pagy_nav_js:                 path.join('pagy/nav_js'),
                           pagy_combo_nav_js:           path.join('pagy/combo_nav_js'),
                           pagy_prev_url:               path.join('pagy/helpers'),
                           pagy_next_url:               path.join('pagy/helpers'),
                           pagy_prev_link:              path.join('pagy/helpers'),
                           pagy_next_link:              path.join('pagy/helpers'),
                           pagy_info:                   path.join('pagy/info'),
                           pagy_limit_selector_js:      path.join('pagy/limit_selector'),
                           pagy_prev_a:                 path.join('pagy/prev_next'),
                           pagy_next_a:                 path.join('pagy/prev_next') }.freeze

      FRONTEND_METHODS.each_key do |method|
        class_eval "alias #{method} pagy_load_frontend", __FILE__, __LINE__  # alias pagy_* pagy_load_frontend
      end
    end
  end
end
