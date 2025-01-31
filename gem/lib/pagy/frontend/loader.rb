# frozen_string_literal: true

class Pagy
  module Frontend
    module Loader
      def pagy_load_frontend(...)
        method_sym = __callee__
        require FRONTEND_METHODS[method_sym]
        send(method_sym, ...)
      end

      FRONTEND_METHODS = { pagy_bootstrap_combo_nav_js: PAGY_PATH.join('frontend/bootstrap/combo_nav_js'),
                           pagy_bootstrap_nav:          PAGY_PATH.join('frontend/bootstrap/nav'),
                           pagy_bootstrap_nav_js:       PAGY_PATH.join('frontend/bootstrap/nav_js'),
                           pagy_bulma_combo_nav_js:     PAGY_PATH.join('frontend/bulma/combo_nav_js'),
                           pagy_bulma_nav:              PAGY_PATH.join('frontend/bulma/nav'),
                           pagy_bulma_nav_js:           PAGY_PATH.join('frontend/bulma/nav_js'),
                           pagy_combo_nav_js:           PAGY_PATH.join('frontend/pagy/combo_nav_js'),
                           pagy_nav:                    PAGY_PATH.join('frontend/pagy/nav'),
                           pagy_nav_js:                 PAGY_PATH.join('frontend/pagy/nav_js'),
                           pagy_previous_url:           PAGY_PATH.join('frontend/pagy/helpers'),
                           pagy_next_url:               PAGY_PATH.join('frontend/pagy/helpers'),
                           pagy_previous_link:          PAGY_PATH.join('frontend/pagy/helpers'),
                           pagy_next_link:              PAGY_PATH.join('frontend/pagy/helpers'),
                           pagy_info:                   PAGY_PATH.join('frontend/pagy/info'),
                           pagy_limit_selector_js:      PAGY_PATH.join('frontend/pagy/limit_selector'),
                           pagy_previous_a:             PAGY_PATH.join('frontend/pagy/previous_next'),
                           pagy_next_a:                 PAGY_PATH.join('frontend/pagy/previous_next') }.freeze

      FRONTEND_METHODS.each_key do |method|
        class_eval "alias #{method} pagy_load_frontend", __FILE__, __LINE__  # alias pagy_* pagy_load_frontend
      end
    end
  end
end
