# frozen_string_literal: true

class Pagy
  module Loader
    paths = { public:    { page_url:                'page_url',
                           data_hash:               'data_hash',
                           headers_hash:            'headers_hash',
                           links_hash:              'links_hash',
                           next_tag:                'anchor_tags',
                           previous_tag:            'anchor_tags',
                           input_nav_js:            'input_nav_js',
                           info_tag:                'info_tag',
                           limit_tag_js:            'limit_tag_js',
                           series_nav:              'series_nav',
                           series_nav_js:           'series_nav_js' },
              protected: { bootstrap_series_nav:    'bootstrap/series_nav',
                           bootstrap_series_nav_js: 'bootstrap/series_nav_js',
                           bootstrap_input_nav_js:  'bootstrap/input_nav_js',
                           bulma_series_nav:        'bulma/series_nav',
                           bulma_series_nav_js:     'bulma/series_nav_js',
                           bulma_input_nav_js:      'bulma/input_nav_js' } }.freeze

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
