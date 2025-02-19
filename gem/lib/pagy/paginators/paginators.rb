# frozen_string_literal: true

class Pagy
  # Get the option values from params
  module Get
    module_function

    # Check the use of jsonapi and its consistency
    def jsonapi?(params, options)
      return false unless params[:page] && options[:jsonapi] # rubocop:disable Layout/EmptyLineAfterGuardClause
      params[:page].respond_to?(:fetch) || raise(JsonapiReservedParamError, params[:page])
    end

    # Get the limit from the request
    def requested_limit(params, options)
      limit_sym = options[:limit_sym] || DEFAULT[:limit_sym]
      jsonapi?(params, options) ? params[:page][limit_sym] : params[limit_sym]
    end

    # Get the limit from request, options or DEFAULT
    def limit_from(params, options)
      return options[:limit] || DEFAULT[:limit] \
      unless options[:requestable_limit] && (limit = requested_limit(params, options))

      [limit.to_i, options[:requestable_limit]].min
    end

    # Get the page integer from the params
    def page_from(params, options, force_integer: true)
      page_sym = options[:page_sym] || DEFAULT[:page_sym]
      page     = jsonapi?(params, options) ? params[:page][page_sym] : params[page_sym]
      force_integer ? (page || 1).to_i : page
    end

    # Get the hash of elements for the URL
    def hash_from(request)
      { base_url:     request.base_url,
        path:         request.path,
        query_params: request.GET }
    end
  end

  # Include in the app controller
  module Paginators
    protected

    # Define the autoloading system for each paginator method and its implementing classes
    paginators = { pagy_array:               'array',
                   pagy_calendar:            'calendar',
                   pagy_countless:           'countless',
                   pagy_keynav_js:           'keynav',
                   pagy_keyset:              'keyset',
                   pagy_offset:              'offset',
                   pagy_elasticsearch_rails: 'searches/elasticsearch_rails',
                   pagy_meilisearch:         'searches/meilisearch',
                   pagy_searchkick:          'searches/searchkick' }.freeze

    # Load the paginator code, which overrides its alias and will be called directly in next requests
    define_method :pagy_load_paginator do |*args, **kwargs|
      method_sym = __callee__                  # Get the method name
      require_relative paginators[method_sym]  # Load its code
      send(method_sym, *args, **kwargs)        # Forward the call to it
    end

    # Define each alias that triggers the loader
    paginators.each_key do |method|
      module_eval "alias #{method} pagy_load_paginator", __FILE__, __LINE__  # alias pagy_* pagy_load_paginator
    end
  end
end
