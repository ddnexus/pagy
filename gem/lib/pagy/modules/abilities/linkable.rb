# frozen_string_literal: true

require 'uri'

class Pagy
  # Support spaces in placeholder params
  class EscapedValue < String; end

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

          escaped_value = value.is_a?(EscapedValue) ? value : escape(value)
          "#{escape(prefix)}=#{escaped_value}"
        end
      end

      def escape(str)
        URI.encode_www_form_component(str)
      end
    end

    protected

    # Overriddable by classes with composite page param
    def compose_page_param(page) = page

    # Return the URL for the page, relying on the Pagy::Request
    def compose_page_url(page, **options)
      root_key, page_key, limit_key, client_max_limit, limit, querify, absolute, path, fragment =
        @options.merge(options)
                .values_at(:root_key, :page_key, :limit_key, :client_max_limit, :limit, :querify, :absolute, :path, :fragment)
      params = @request.params.clone(freeze: false)
      # Deep clone nested params to prevent modifying the original request params when using root_key
      params[root_key] = params[root_key]&.then { |h| h.respond_to?(:deep_dup) ? h.deep_dup : h.dup } if root_key
      (root_key ? params[root_key] ||= {} : params).tap do |h|
        { page_key  => compose_page_param(page),
          limit_key => client_max_limit && limit }.each { |k, v| v ? h[k] = v : h.delete(k) }
      end
      querify&.(params) # Must modify the params: the returned value is ignored
      query_string = QueryUtils.build_nested_query(params).sub(/\A(?=.)/, '?')
      fragment   &&= "##{fragment.delete_prefix('#')}"
      "#{@request.base_url if absolute}#{path || @request.path}#{query_string}#{fragment}"
    end
  end
end
