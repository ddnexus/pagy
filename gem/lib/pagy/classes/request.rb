# frozen_string_literal: true

class Pagy
  class Request
    def initialize(request, options = {})
      @base_url, @path, @query_hash = if request.is_a?(Hash)
                                        request.values_at(:base_url, :path, :query_hash)
                                      else
                                        [request.base_url, request.path, request.GET]
                                      end
      @jsonapi = @query_hash['page'] && options[:jsonapi]
      raise JsonapiReservedParamError, @query_hash['page'] if @jsonapi && !@query_hash['page'].respond_to?(:fetch)
    end
    attr_reader :base_url, :path, :query_hash

    # Get the page
    def page(options, force_integer: true)
      page_key = options[:page_key] || DEFAULT[:page_key]
      page = @jsonapi ? @query_hash['page'][page_key] : @query_hash[page_key]
      force_integer ? (page || 1).to_i : page
    end

    # Get the limit
    def limit(options)
      limit_key = options[:limit_key] || DEFAULT[:limit_key]
      return options[:limit] || DEFAULT[:limit] \
             unless options[:requestable_limit] &&
                    (requested_limit = @jsonapi ? @query_hash['page'][limit_key] : @query_hash[limit_key])

      [requested_limit.to_i, options[:requestable_limit]].min
    end
  end
end
