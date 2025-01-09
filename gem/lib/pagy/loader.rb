# frozen_string_literal: true

class Pagy
  module Loader
    METHOD_MIXINS = { pagy_arel:                   :arel,
                      pagy_array:                  :array,
                      pagy_bootstrap_nav:          :bootstrap,
                      pagy_bootstrap_nav_js:       :bootstrap,
                      pagy_bootstrap_combo_nav_js: :bootstrap,
                      pagy_bulma_nav:              :bulma,
                      pagy_bulma_nav_js:           :bulma,
                      pagy_bulma_combo_nav_js:     :bulma,
                      pagy_calendar:               :calendar,
                      pagy_countless:              :countless,
                      new_from_elasticserch_rails: :elasticsearch_rails,
                      pagy_elasticsearch_rails:    :elasticsearch_rails,
                      pagy_headers:                :headers,
                      pagy_headers_merge:          :headers,
                      pagy_keyset:                 :keyset,
                      pagy_keyset_augmented_js:    :keyset_augmented,
                      pagy_limit_selector_js:      :limit_selector,
                      new_from_meilisearch:        :meilisearch,
                      pagy_meilisearch:            :meilisearch,
                      pagy_metadata:               :metadata,
                      pagy_offset:                 :offset,
                      pagy_nav:                    :pagy,
                      pagy_nav_js:                 :pagy,
                      pagy_combo_nav_js:           :pagy,
                      pagy_prev_url:               :pagy_helpers,
                      pagy_next_url:               :pagy_helpers,
                      pagy_prev_a:                 :pagy_helpers,
                      pagy_next_a:                 :pagy_helpers,
                      pagy_prev_link:              :pagy_helpers,
                      pagy_next_link:              :pagy_helpers,
                      new_from_searchkick:         :searchkick,
                      pagy_searchkick:             :searchkick }.freeze

    def respond_to_missing?(method, ...)
      METHOD_MIXINS.key?(method) || super
    end

    def method_missing(method, ...)
      return super unless respond_to?(method)

      require_relative "mixins/#{METHOD_MIXINS[method]}"
      send(method, ...)
    end
  end
end
