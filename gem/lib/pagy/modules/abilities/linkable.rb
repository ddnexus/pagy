# frozen_string_literal: true

require 'uri'

class Pagy
  # Provide the helpers to handle the url and anchor
  module Linkable
    module QueryUtils
      module_function

      # Extracted from Rack::Utils and reformatted for rubocop
      # Allow unescaped Pagy::RawQueryValue
      def build_nested_query(value, prefix = nil)
        case value
        when Array
          value.map { |v| build_nested_query(v, "#{prefix}[]") }.join('&')
        when Hash
          value.map do |k, v|
            build_nested_query(v, prefix ? "#{prefix}[#{k}]" : k)
          end.delete_if(&:empty?).join('&')
        when nil
          escape(prefix)
        else
          raise ArgumentError, 'value must be a Hash' if prefix.nil?

          final_value = value.is_a?(RawQueryValue) ? value.to_s : escape(value)
          "#{escape(prefix)}=#{final_value}"
        end
      end

      def escape(str)
        URI.encode_www_form_component(str)
      end
    end

    protected

    # Return the URL for the page, relying on the Pagy::Request
    def compose_page_url(page, limit_token: nil, **options)
      root_key, page_key, limit_key, limit, client_max_limit, querify, absolute, path, fragment =
        @options.merge(options)
                .values_at(:root_key, :page_key, :limit_key, :limit, :client_max_limit, :querify, :absolute, :path, :fragment)
      params = @request.params.clone(freeze: false)
      (root_key ? params[root_key] ||= {} : params).tap do |h|
        { page_key  => countless? ? RawQueryValue.new(compose_page_param(page)) : page,
          limit_key => (limit_token || limit if client_max_limit) }.each { |k, v| v ? h[k] = v : h.delete(k) }
      end
      querify&.(params) # Must modify the params: the returned value is ignored
      query_string = QueryUtils.build_nested_query(params)
      query_string = "?#{query_string}" unless query_string.empty?
      fragment   &&= %(##{fragment}) unless fragment&.start_with?('#')
      "#{@request.base_url if absolute}#{path || @request.path}#{query_string}#{fragment}"
    end
  end
end
