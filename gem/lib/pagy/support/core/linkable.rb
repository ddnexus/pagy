# frozen_string_literal: true

require 'uri'

class Pagy
  module Core
    # Provide the helpers to handle the url in frontend and backend
    module Linkable
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
      # It supports all rack-based frameworks (Sinatra, Padrino, Rails, Roda, Anami, ...).
      # For non-rack environments that don't respond to the request method, pass the :request option to the paginator
      # with your request[:url_prefix] (i.e. everything that comes before the ? in the complete url),
      # and your request[:query_params] hash to be merged with the pagy params and form the complete url
      def page_url(page, absolute: false, fragment: nil, limit_token: nil, **)
        request_var, pagy_params = (options = @options).values_at(:request, :params)
        raise OptionError.new(self, :request, 'to be defined', nil) unless @request || request_var

        page_name, limit_name    = options.values_at(:page_sym, :limit_sym).map(&:to_s)
        query_params             = request_var ? (request_var[:query_params] || {}) : @request.GET.clone(freeze: false)
        query_params.permit(page_name, limit_name) if query_params.respond_to?(:permit)
        query_params.delete(options[:jsonapi] ? 'page' : page_name)
        page_and_limit = {}.tap do |h|
          h[page_name]  = countless? ? "#{page || 1}+#{@last}" : page
          h[limit_name] = limit_token || options[:limit] if options[:requestable_limit]
        end.compact # no empty params
        query_params.merge!(options[:jsonapi] ? { 'page' => page_and_limit } : page_and_limit) if page_and_limit.size.positive?
        case pagy_params
        when Hash then query_params.merge!(pagy_params.compact.transform_keys(&:to_s))
        when Proc then pagy_params.(query_params) # it should modify the query_params: the returned value is ignored
        end
        query_string = QueryUtils.build_nested_query(query_params, nil, [page_name, limit_name])
        query_string = "?#{query_string}" unless query_string.empty?
        return "#{request_var[:url_prefix]}#{query_string}#{fragment}" if request_var

        "#{@request.base_url if absolute}#{options[:request_path] || @request.path}#{query_string}#{fragment}"
      end

      # Label for any page. Allow the customization of the output (overridden by the calendar)
      def label(page: @page, **) = page.to_s

      # Return a performance optimized lambda to generate the HTML anchor element (a tag)
      # Benchmarked on a 20 link nav: it is ~22x faster and uses ~18x less memory than rails' link_to
      def anchor_lambda(anchor_string: nil, **)
        left, right = %(<a#{%( #{anchor_string}) if anchor_string} href="#{page_url(PAGE_TOKEN, **)}")
                      .split(PAGE_TOKEN, 2)
        # Lambda used by all the helpers
        lambda do |page, text = label(page: page), classes: nil, aria_label: nil|
          %(#{left}#{page}#{right}#{%( class="#{classes}") if classes}#{%( aria-label="#{aria_label}") if aria_label}>#{text}</a>)
        end
      end
    end
  end
end
