# frozen_string_literal: true

class Pagy
  module Loader
    methods_definitions = { public:    { page_url:                   'helpers/page_url',
                                         data_hash:                  'helpers/data_hash',
                                         headers_hash:               'helpers/headers_hash',
                                         links_hash:                 'helpers/links_hash',
                                         next_a_tag:                 'components/a_tags',
                                         previous_a_tag:             'components/a_tags',
                                         combo_nav_js_tag:           'components/combo_nav_js_tag',
                                         info_tag:                   'components/info_tag',
                                         limit_selector_js_tag:      'components/limit_selector_js_tag',
                                         previous_link_tag:          'components/link_tags',
                                         next_link_tag:              'components/link_tags',
                                         nav_tag:                    'components/nav_tag',
                                         nav_js_tag:                 'components/nav_js_tag' },
                            protected: { bootstrap_nav_tag:          'components/bootstrap/nav_tag',
                                         bootstrap_nav_js_tag:       'components/bootstrap/nav_js_tag',
                                         bootstrap_combo_nav_js_tag: 'components/bootstrap/combo_nav_js_tag',
                                         bulma_nav_tag:              'components/bulma/nav_tag',
                                         bulma_nav_js_tag:           'components/bulma/nav_js_tag',
                                         bulma_combo_nav_js_tag:     'components/bulma/combo_nav_js_tag' } }.freeze

    methods_definitions.each do |visibility, methods|
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
