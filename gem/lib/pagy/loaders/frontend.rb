# frozen_string_literal: true

class Pagy
  module Loaders
    module Frontend
      def pagy_load_frontend(...)
        method_sym = __callee__
        require FRONTEND_METHOD_MIXINS[method_sym]
        send(method_sym, ...)
      end

      FRONTEND_METHOD_MIXINS = { pagy_bootstrap_nav:          PAGY_PATH.join('mixins/bootstrap').to_s,
                                 pagy_bootstrap_nav_js:       PAGY_PATH.join('mixins/bootstrap').to_s,
                                 pagy_bootstrap_combo_nav_js: PAGY_PATH.join('mixins/bootstrap').to_s,
                                 pagy_bulma_nav:              PAGY_PATH.join('mixins/bulma').to_s,
                                 pagy_bulma_nav_js:           PAGY_PATH.join('mixins/bulma').to_s,
                                 pagy_bulma_combo_nav_js:     PAGY_PATH.join('mixins/bulma').to_s,
                                 pagy_limit_selector_js:      PAGY_PATH.join('mixins/limit_selector').to_s,
                                 pagy_nav:                    PAGY_PATH.join('mixins/pagy').to_s,
                                 pagy_nav_js:                 PAGY_PATH.join('mixins/pagy').to_s,
                                 pagy_combo_nav_js:           PAGY_PATH.join('mixins/pagy').to_s,
                                 pagy_prev_url:               PAGY_PATH.join('mixins/pagy_helpers').to_s,
                                 pagy_next_url:               PAGY_PATH.join('mixins/pagy_helpers').to_s,
                                 pagy_prev_a:                 PAGY_PATH.join('mixins/pagy_helpers').to_s,
                                 pagy_next_a:                 PAGY_PATH.join('mixins/pagy_helpers').to_s,
                                 pagy_prev_link:              PAGY_PATH.join('mixins/pagy_helpers').to_s,
                                 pagy_next_link:              PAGY_PATH.join('mixins/pagy_helpers').to_s }.freeze

      FRONTEND_METHOD_MIXINS.each_key do |method|
        class_eval "alias #{method} pagy_load_frontend", __FILE__, __LINE__  # alias pagy_* pagy_load_frontend
      end
    end
  end
end
