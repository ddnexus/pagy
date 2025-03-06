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
      options = @options.merge(options)
      request, page_key, limit_key, params = options.values_at(:request, :page_key, :limit_key, :params)
      query_params = request.params.clone(freeze: false)
      query_params.delete(options[:jsonapi] ? 'page' : page_key)
      page_and_limit = {}.tap do |h|
        h[page_key]  = countless? ? "#{page || 1}+#{@last}" : page
        h[limit_key] = limit_token || options[:limit] if options[:requestable_limit]
      end.compact # no empty params
      query_params.merge!(options[:jsonapi] ? { 'page' => page_and_limit } : page_and_limit) if page_and_limit.size.positive?
      case params
      when Hash then query_params.merge!(params.compact.transform_keys(&:to_s))
      when Proc then params.(query_params) # it should modify the query_params: the returned value is ignored
      end
      query_string = QueryUtils.build_nested_query(query_params, nil, [page_key, limit_key])
      query_string = "?#{query_string}" unless query_string.empty?
      "#{request.base_url if options[:absolute]}#{options[:request_path] || request.path}#{query_string}#{options[:fragment]}"
    end
  end
end
