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
    end

    attr_reader :base_url, :path, :params, :cookie

    def resolve_page(force_integer: true)
      page_key = @options[:page_key] || DEFAULT[:page_key]
      page     = @params.dig(@options[:root_key], page_key) || @params[page_key]
      force_integer ? [page.to_i, 1].max : page
    end

    def resolve_limit
      limit_key = @options[:limit_key] || DEFAULT[:limit_key]
      return @options[:limit] || DEFAULT[:limit] \
             unless @options[:client_max_limit] &&
                    (requested_limit = @params.dig(@options[:root_key], limit_key) || @params[limit_key])

      [requested_limit.to_i, @options[:client_max_limit]].min
    end

    private

    def get_params(request) = request.GET.merge(request.POST).to_h
  end
end
