# frozen_string_literal: true

class Pagy
  module Loader
    paths = { public:    { page_url:                   'page_url',
                           data_hash:                  'data_hash',
                           headers_hash:               'headers_hash',
                           links_hash:                 'links_hash',
                           next_a_tag:                 'a_tags',
                           previous_a_tag:             'a_tags',
                           combo_nav_js_tag:           'combo_nav_js_tag',
                           info_tag:                   'info_tag',
                           limit_selector_js_tag:      'limit_selector_js_tag',
                           nav_tag:                    'nav_tag',
                           nav_js_tag:                 'nav_js_tag' },
              protected: { bootstrap_nav_tag:          'bootstrap/nav_tag',
                           bootstrap_nav_js_tag:       'bootstrap/nav_js_tag',
                           bootstrap_combo_nav_js_tag: 'bootstrap/combo_nav_js_tag',
                           bulma_nav_tag:              'bulma/nav_tag',
                           bulma_nav_js_tag:           'bulma/nav_js_tag',
                           bulma_combo_nav_js_tag:     'bulma/combo_nav_js_tag' } }.freeze

    paths.each do |visibility, methods|
      send(visibility)
      # Load the method, overriding its own alias. Next requests will call the method directly.
      define_method(:"load_#{visibility}") do |*args, **kwargs|
        require_relative methods[__callee__]
        send(__callee__, *args, **kwargs)
      end
      methods.each_key { |method| alias_method method, :"load_#{visibility}" }
    end
  end
end
