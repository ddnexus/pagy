# frozen_string_literal: true

require 'uri'

class Pagy
  # Provide the helpers to handle the url in frontend and backend
  module Url
    # Extracted from Rack::Utils and reformatted for rubocop
    # Add the 'unescaped' param, and use it for simple and safe url-templating.
    module QueryUtils
      module_function

      def build_nested_query(value, prefix = nil, unescaped = [])
        case value
        when Array
          value.map { |v| build_nested_query(v, "#{prefix}[]", unescaped) }.join('&')
        when Hash
          value.map do |k, v|
            new_k = prefix ? "#{prefix}[#{escape(k)}]" : escape(k)
            if unescaped.size.positive? && new_k != k.to_s && unescaped.include?(k.to_s)
              unescaped[unescaped.find_index(k.to_s)] = new_k
            end
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

    # Return the URL for the page, relying on the params method and Rack by default.
    # It supports all rack-based frameworks (Sinatra, Padrino, Rails, ...).
    # For non-rack environments that don't respond to the request method, pass the :request variable to the constructor
    # with your request[:url_prefix] (i.e. everything that comes before the ? in the complete url),
    # and your request[:query_params] hash to be merged with the pagy params and form the complete url
    def pagy_page_url(pagy, page, absolute: false, fragment: nil, **)
      request_var, pagy_params = (vars = pagy.vars).values_at(:request, :params)
      page_name, limit_name    = vars.values_at(:page_sym, :limit_sym).map(&:to_s)
      query_params             = request_var ? (request_var[:query_params] || {}) : request.GET.clone(freeze: false)
      page_and_limit           = { page_name => page }.tap { |h| h[limit_name] = vars[:limit] if vars[:limit_requestable] }
      query_params.merge!(vars[:jsonapi] ? { 'page' => page_and_limit } : page_and_limit)
      case pagy_params
      when Hash then query_params.merge!(pagy_params.transform_keys(&:to_s))
      when Proc then pagy_params.(query_params)
      end
      query_string = "?#{QueryUtils.build_nested_query(query_params, nil, [page_name, limit_name])}"
      return "#{request_var[:url_prefix]}#{query_string}#{fragment}" if request_var

      "#{request.base_url if absolute}#{vars[:request_path] || request.path}#{query_string}#{fragment}"
    end
  end
end
