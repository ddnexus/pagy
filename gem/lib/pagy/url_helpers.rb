# frozen_string_literal: true

class Pagy
  # Provide the helpers to handle the url in frontend and backend
  module UrlHelpers
    # Extracted from Rack::Utils and reformatted for rubocop
    # Add the 'unescaped' param, and use it for simple and safe templating.
    module QueryUtils
      module_function

      def build_nested_query(value, prefix = nil, unescaped = [])
        case value
        when Array
          value.map { |v| build_nested_query(v, "#{prefix}[]", unescaped) }.join('&')
        when Hash
          value.map do |k, v|
            build_nested_query(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k), unescaped)
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
    # It supports all Rack-based frameworks (Sinatra, Padrino, Rails, ...).
    # For non-rack environments you can use the standalone extra
    def pagy_url_for(pagy, page, absolute: false, fragment: nil, **_)
      vars         = pagy.vars
      query_params = vars[:url] ? {} : request.GET.clone(freeze: false)
      query_params.merge!(vars[:params].transform_keys(&:to_s)) if vars[:params].is_a?(Hash)
      pagy_set_query_params(page, vars, query_params)
      query_params = vars[:params].(query_params) if vars[:params].is_a?(Proc)
      query_string = "?#{QueryUtils.build_nested_query(query_params, nil,
                                                       %i[page_sym limit_sym].map { |k| pagy.vars[k].to_s })}"
      if vars[:url]
        "#{vars[:url]}#{query_string}#{fragment}"
      else
        "#{request.base_url if absolute}#{vars[:request_path] || request.path}#{query_string}#{fragment}"
      end
    end

    # Add the page and limit params
    # Overridable by the jsonapi extra
    def pagy_set_query_params(page, vars, query_params)
      query_params[vars[:page_sym].to_s]  = page
      query_params[vars[:limit_sym].to_s] = vars[:limit] if vars[:limit_extra]
    end
  end
end
