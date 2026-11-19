# frozen_string_literal: true

class Pagy
  # Decouple the request from the env, allowing non-rack apps to use pagy by passing a hash.
  # Resolve the :page and :limit options from params.
  class Request
    def initialize(options)
      @options = options
      request  = @options[:request]
      @base_url, @path, @params, @cookie =
        if request.is_a?(Hash)
          request.values_at(:base_url, :path, :params, :cookie)
        else
          [request.base_url, request.path, get_params(request), request.cookies['pagy']]
        end
      freeze
    end

    attr_reader :base_url, :path, :params, :cookie

    def resolve_page(force_integer: true)
      page_key = @options[:page_key] || DEFAULT[:page_key]
      page     = fetch_param(page_key)
      return [page.to_s.to_i, 1].max if force_integer

      page if page.is_a?(String) && !page.empty?
    end

    def resolve_limit
      default      = @options[:limit] || DEFAULT[:limit]
      client_limit = @options[:client_limit]
      return default unless client_limit

      limit_key = @options[:limit_key] || DEFAULT[:limit_key]
      limit     = fetch_param(limit_key).to_s.to_i
      limit.positive? ? [limit, client_limit].min : default
    end

    private

    # The client may send a non-Hash value for the root_key (e.g. ?page=2 with the jsonapi root_key 'page')
    def fetch_param(key)
      scope = @params[@options[:root_key]]
      (scope[key] if scope.is_a?(Hash)) || @params[key]
    end

    # Overriding support
    def get_params(request)
      request.GET.merge(request.POST).to_h.freeze
    end

    prepend Deprecated::Request if defined?(Deprecated::Request)
  end
end
