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
    # For non-rack environments that don't respond to the request method, pass the :request option to the paginator
    # with your request[:url_prefix] (i.e. everything that comes before the ? in the complete url),
    # and your request[:query_params] hash to be merged with the pagy params and form the complete url
    def pagy_page_url(pagy, page, absolute: false, fragment: nil, limit_token: nil, **)
      request_var, pagy_params = (options = pagy.options).values_at(:request, :params)
      page_name, limit_name    = options.values_at(:page_sym, :limit_sym).map(&:to_s)
      query_params             = request_var ? (request_var[:query_params] || {}) : request.GET.clone(freeze: false)
      query_params.delete(options[:jsonapi] ? 'page' : page_name)
      page_and_limit = {}.tap do |h|
                         h[page_name]  = pagy.page_for_url(page)
                         h[limit_name] = limit_token || options[:limit] if options[:requestable_limit]
                       end.compact # no empty params
      query_params.merge!(options[:jsonapi] ? { 'page' => page_and_limit } : page_and_limit) if page_and_limit.size.positive?
      case pagy_params
      when Hash then query_params.merge!(pagy_params.transform_keys(&:to_s).compact)
      when Proc then pagy_params.(query_params) # it should modify the query_params: the returned value is ignored
      end
      query_string = QueryUtils.build_nested_query(query_params, nil, [page_name, limit_name])
      query_string = "?#{query_string}" unless query_string.empty?
      return "#{request_var[:url_prefix]}#{query_string}#{fragment}" if request_var

      "#{request.base_url if absolute}#{options[:request_path] || request.path}#{query_string}#{fragment}"
    end

    # Return the url for the calendar page at time
    def pagy_calendar_url_at(calendar, time, **)
      pagy_page_url(calendar.send(:calendar_at, time, **), 1, **)
    end
  end
end
