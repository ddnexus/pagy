# frozen_string_literal: true

class Pagy
  module Loader
    # Define the autoloading system for each helper/component method
    methods = { page_url:              'helpers/page_url',
                data_hash:             'helpers/data_hash',
                headers_hash:          'helpers/headers_hash',
                links_hash:            'helpers/links_hash',
                next_a_tag:            'components/a_tags',
                previous_a_tag:        'components/a_tags',
                combo_nav_js_tag:      'components/combo_nav_js_tag',
                info_tag:              'components/info_tag',
                limit_selector_js_tag: 'components/limit_selector_js_tag',
                previous_link_tag:     'components/link_tags',
                next_link_tag:         'components/link_tags',
                nav_tag:               'components/nav_tag',
                nav_js_tag:            'components/nav_js_tag' }.freeze

    # Load the code, which overrides its alias and will be called directly in next requests
    define_method :load_method do |*args, **kwargs|
      method_sym = __callee__
      require_relative methods[method_sym]
      send(method_sym, *args, **kwargs)
    end

    # Define each alias that triggers the loader
    methods.each_key do |method|
      class_eval "alias #{method} load_method", __FILE__, __LINE__ # alias * load_method
    end
  end
end
