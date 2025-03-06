# frozen_string_literal: true

class Pagy
  class Request
    def initialize(request, options = {})
      @base_url, @path, @params = if request.is_a?(Hash)
                                    request.values_at(:base_url, :path, :params)
                                  else
                                    [request.base_url, request.path, request.GET]
                                  end
      @jsonapi = @params['page'] && options[:jsonapi]
      raise JsonapiReservedParamError, @params['page'] if @jsonapi && !@params['page'].respond_to?(:fetch)
    end
    attr_reader :base_url, :path, :params

    # Get the page
    def page(options, force_integer: true)
      page_key = options[:page_key] || DEFAULT[:page_key]
      page = @jsonapi ? @params['page'][page_key] : @params[page_key]
      force_integer ? (page || 1).to_i : page
    end

    # Get the limit
    def limit(options)
      limit_key = options[:limit_key] || DEFAULT[:limit_key]
      return options[:limit] || DEFAULT[:limit] \
             unless options[:requestable_limit] &&
                    (requested_limit = @jsonapi ? @params['page'][limit_key] : @params[limit_key])

      [requested_limit.to_i, options[:requestable_limit]].min
    end
  end
end
