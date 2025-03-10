# frozen_string_literal: true

require 'uri'

class Pagy
  # Provide the helpers to handle the url and anchor
  module Linkable
    module QueryUtils
      module_function

      # Extracted from Rack::Utils and reformatted for rubocop
      # Add the 'unescaped' param, and use it for simple and safe url-templating.
      # All string keyed hashes
      def build_nested_query(value, prefix = nil, unescaped = [])
        case value
        when Array
          value.map { |v| build_nested_query(v, "#{prefix}[]", unescaped) }.join('&')
        when Hash
          value.map do |k, v|
            new_k = prefix ? "#{prefix}[#{escape(k)}]" : escape(k)
            unescaped[unescaped.find_index(k)] = new_k if unescaped.size.positive? && new_k != k && unescaped.include?(k)
            build_nested_query(v, new_k, unescaped)
          end.delete_if(&:empty?).join('&')
        when nil
          escape(prefix)
        else
          raise ArgumentError, 'value must be a Hash' if prefix.nil?
          return "#{escape(prefix)}=#{value}" if unescaped.include?(prefix)

          "#{escape(prefix)}=#{escape(value)}"
        end
      end

      def escape(str)
        URI.encode_www_form_component(str)
      end
    end

    protected

    # Return the URL for the page, relying on the Pagy::Request
    def compose_page_url(page, limit_token: nil, **options)
      jsonapi, page_key, limit_key, limit, requestable_limit, querify, absolute, path, fragment =
        @options.merge(options)
                .values_at(:jsonapi, :page_key, :limit_key, :limit, :requestable_limit, :querify, :absolute, :path, :fragment)
      query = @request.queried.clone(freeze: false)
      query.delete(jsonapi ? 'page' : page_key)
      paging = {}.tap do |h|
                 h[page_key]  = countless? ? "#{page || 1}+#{@last}" : page
                 h[limit_key] = limit_token || limit if requestable_limit
               end.compact # No empty params
      query.merge!(jsonapi ? { 'page' => paging } : paging) if paging.size.positive?
      querify&.(query) # Must modify the queried: the returned value is ignored
      query_string = QueryUtils.build_nested_query(query, nil, [page_key, limit_key])
      query_string = "?#{query_string}" unless query_string.empty?
      "#{@request.base_url if absolute}#{path || @request.path}#{query_string}#{fragment}"
    end
  end
end
