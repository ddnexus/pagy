# frozen_string_literal: true

class Pagy
  # Decouple the reuest from the env, allowing non-rack apps to use pagy by passing a hash.
  # Resolve :page and :limit, supporting the :jsonapi option. Support URL composition.
  class Request
    def initialize(request, options = {})
      @base_url, @path, @queried, @cookie =
        if request.is_a?(Hash)
          request.values_at(:base_url, :path, :queried, :cookie)
        else
          [request.base_url, request.path, request.GET, request.cookies['pagy']]
        end
      @jsonapi = @queried['page'] && options[:jsonapi]
      raise JsonapiReservedParamError, @queried['page'] if @jsonapi && !@queried['page'].respond_to?(:fetch)
    end

    attr_reader :base_url, :path, :queried, :cookie

    def resolve_page(options, force_integer: true)
      page_key = options[:page_key] || DEFAULT[:page_key]
      page     = @jsonapi ? @queried['page'][page_key] : @queried[page_key]
      force_integer ? (page || 1).to_i : page
    end

    def resolve_limit(options)
      limit_key = options[:limit_key] || DEFAULT[:limit_key]
      return options[:limit] || DEFAULT[:limit] \
             unless options[:requestable_limit] &&
                    (requested_limit = @jsonapi ? @queried['page'][limit_key] : @queried[limit_key])

      [requested_limit.to_i, options[:requestable_limit]].min
    end
  end
end
