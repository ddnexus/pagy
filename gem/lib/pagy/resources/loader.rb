# frozen_string_literal: true

class Pagy
  module Loader
    pagy_methods = { page_url:              'helpers/page_url',
                     pluck_hash:            'helpers/pluck_hash',
                     headers_hash:          'helpers/headers_hash',
                     links_hash:            'helpers/links_hash',
                     next_a_tag:            'components/previous_next_tags',
                     previous_a_tag:        'components/previous_next_tags',
                     combo_nav_js_tag:      'components/combo_nav_js_tag',
                     info_tag:              'components/info_tag',
                     limit_selector_js_tag: 'components/limit_selector_js_tag',
                     previous_link_tag:     'components/link_tags',
                     next_link_tag:         'components/link_tags',
                     nav_tag:               'components/nav_tag',
                     nav_js_tag:            'components/nav_js_tag' }.freeze

    define_method :load_method do |*args, **kwargs|
      method_sym = __callee__
      require_relative pagy_methods[method_sym]
      send(method_sym, *args, **kwargs)
    end

    pagy_methods.each_key do |method|
      class_eval "alias #{method} load_method", __FILE__, __LINE__ # alias * load_method
    end
  end
end
