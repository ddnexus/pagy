# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/standalone
# frozen_string_literal: true

require 'uri'
class Pagy
  module StandaloneExtra
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
          value.map do |k, v|
            build_nested_query(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k))
          end.delete_if(&:empty?).join('&')
        when nil
          prefix
        else
          raise ArgumentError, 'value must be a Hash' if prefix.nil?

          "#{prefix}=#{escape(value)}"
        end
      end
    end

    # without any :url var it works exactly as the regular #pagy_url_for;
    # with a defined :url variable it does not use rack/request
    def pagy_url_for(pagy, page, absolute: nil)
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
      params[p_vars[:items_param].to_s] = p_vars[:items] if defined?(ItemsExtra)
      query_string = "?#{QueryUtils.build_nested_query(pagy_get_params(params))}" unless params.empty?
      "#{url_string}#{query_string}#{p_vars[:fragment]}"
    end
  end

  #  single line in order to avoid complicating simplecov reporting (already tested with other GitHub Actions)
  (Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.0.0') \
      && Helpers.prepend(StandaloneExtra)) \
      || (Frontend.prepend(StandaloneExtra); Backend.prepend(StandaloneExtra) if defined?(Pagy::Backend::METADATA)) # rubocop:disable Style/Semicolon

  # defines a dummy #params method if not already defined in the including module
  module Backend
    def self.included(controller)
      controller.define_method(:params) { {} } unless controller.method_defined?(:params)
    end
  end
end
