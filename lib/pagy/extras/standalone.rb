# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/standalone
# frozen_string_literal: true

require 'uri'
class Pagy

  # extracted from Rack::Utils and reformatted for rubocop
  module QueryUtils
    module_function
    def escape(str)
      URI.encode_www_form_component(str)
    end
    def build_nested_query(value, prefix = nil)
      case value
      when Array
        value.map { |v| build_nested_query(v, "#{prefix}[]") }.join('&')
      when Hash
        value.map { |k, v| build_nested_query(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k)) }.delete_if(&:empty?).join('&')
      when nil
        prefix
      else
        raise ArgumentError, 'value must be a Hash' if prefix.nil?
        "#{prefix}=#{escape(value)}"
      end
    end
  end

  module UseStandaloneExtra
    # without any :url var it works exactly as the regular #pagy_url_for;
    # with a defined :url variable it does not use rack/request
    def pagy_url_for(pagy, page, deprecated_url=nil, absolute: nil)
      absolute = Pagy.deprecated_arg(:url, deprecated_url, :absolute, absolute) if deprecated_url
      pagy, page = Pagy.deprecated_order(pagy, page) if page.is_a?(Pagy)
      p_vars = pagy.vars
      if p_vars[:url]
        url_string = p_vars[:url]
        params     = {}
      else
        url_string = "#{request.base_url if absolute}#{request.path}"
        params     = request.GET
      end
      params = params.merge(p_vars[:params])
      params[p_vars[:page_param].to_s]  = page
      params[p_vars[:items_param].to_s] = p_vars[:items] if defined?(UseItemsExtra)
      query_string = "?#{QueryUtils.build_nested_query(pagy_get_params(params))}" unless params.empty?
      "#{url_string}#{query_string}#{p_vars[:fragment]}"
    end
  end
  Helpers.prepend UseStandaloneExtra

  # defines a dummy #params method if not already defined in the including module
  module Backend
    def self.included(controller)
      controller.define_method(:params){{}} unless controller.method_defined?(:params)
    end
  end

  # include Pagy::Console in irb/rails console for a ready to use pagy environment
  module Console
    def self.included(main)
      main.include(Backend)
      main.include(Frontend)
      VARS[:url] = 'http://www.example.com/subdir'
    end

    def pagy_extras(*extras)
      extras.each {|extra| require "pagy/extras/#{extra}"}
    end
  end

end
