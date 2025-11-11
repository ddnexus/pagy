# frozen_string_literal: true

class Pagy
  # Decouple the reuest from the env, allowing non-rack apps to use pagy by passing a hash.
  # Resolve :page and :limit, supporting the :jsonapi option. Support for URL composition.
  #
  class Request
    def initialize(request, options = {})
      @base_url, @path, @params, @cookie =
        if request.is_a?(Hash)
          request.values_at(:base_url, :path, :params, :cookie)
        else
          [request.base_url, request.path, request.GET.merge(request.POST), request.cookies['pagy']]
        end
      @jsonapi = @params['page'] && options[:jsonapi]
      raise JsonapiReservedParamError, @params['page'] if @jsonapi && !@params['page'].respond_to?(:fetch)
    end

    attr_reader :base_url, :path, :params, :cookie

    def resolve_page(options, force_integer: true)
      page_key = options[:page_key] || DEFAULT[:page_key]
      page     = @jsonapi ? @params['page'][page_key] : @params[page_key]
      page     = nil if page == ''   # fix for app-generated queries like ?page=
      force_integer ? (page || 1).to_i : page
    end

    def resolve_limit(options)
      limit_key = options[:limit_key] || DEFAULT[:limit_key]
      return options[:limit] || DEFAULT[:limit] \
             unless options[:client_max_limit] &&
                    (requested_limit = @jsonapi ? @params['page'][limit_key] : @params[limit_key])

      [requested_limit.to_i, options[:client_max_limit]].min
    end
  end
end
