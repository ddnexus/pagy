# frozen_string_literal: true

class Pagy
  class Loaders
    module Frontend
      def pagy_load_frontend(...)
        method_sym = __callee__
        require_relative FRONTEND_METHOD_MIXINS[method_sym]
        send(method_sym, ...)
      end

      FRONTEND_METHOD_MIXINS = { pagy_bootstrap_nav:          '../mixins/bootstrap',
                                 pagy_bootstrap_nav_js:       '../mixins/bootstrap',
                                 pagy_bootstrap_combo_nav_js: '../mixins/bootstrap',
                                 pagy_bulma_nav:              '../mixins/bulma',
                                 pagy_bulma_nav_js:           '../mixins/bulma',
                                 pagy_bulma_combo_nav_js:     '../mixins/bulma',
                                 pagy_limit_selector_js:      '../mixins/limit_selector',
                                 pagy_nav:                    '../mixins/pagy',
                                 pagy_nav_js:                 '../mixins/pagy',
                                 pagy_combo_nav_js:           '../mixins/pagy',
                                 pagy_prev_url:               '../mixins/pagy_helpers',
                                 pagy_next_url:               '../mixins/pagy_helpers',
                                 pagy_prev_a:                 '../mixins/pagy_helpers',
                                 pagy_next_a:                 '../mixins/pagy_helpers',
                                 pagy_prev_link:              '../mixins/pagy_helpers',
                                 pagy_next_link:              '../mixins/pagy_helpers' }.freeze

      FRONTEND_METHOD_MIXINS.each_key do |method|
        class_eval "alias #{method} pagy_load_frontend", __FILE__, __LINE__  # alias pagy_* pagy_load_frontend
      end
    end
  end
end
