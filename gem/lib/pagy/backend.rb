# frozen_string_literal: true

class Pagy
  autoload :OffsetPaginator,             PAGY_PATH.join('paginators/offset')
  autoload :CountlessPaginator,          PAGY_PATH.join('paginators/countless')
  autoload :KeysetPaginator,             PAGY_PATH.join('paginators/keyset')
  autoload :KeynavPaginator,             PAGY_PATH.join('paginators/keynav')
  autoload :CalendarPaginator,           PAGY_PATH.join('paginators/calendar')
  autoload :ElasticsearchRailsPaginator, PAGY_PATH.join('paginators/searches/elasticsearch_rails')
  autoload :MeilisearchPaginator,        PAGY_PATH.join('paginators/searches/meilisearch')
  autoload :SearchkickPaginator,         PAGY_PATH.join('paginators/searches/searchkick')

  # Include in the app controller
  module Backend
    protected

    paginators_map = { offset:              :OffsetPaginator,
                       countless:           :CountlessPaginator,
                       keyset:              :KeysetPaginator,
                       keynav_js:           :KeynavPaginator,
                       calendar:            :CalendarPaginator,
                       elasticsearch_rails: :ElasticsearchRailsPaginator,
                       meilisearch:         :MeilisearchPaginator,
                       searchkick:          :SearchkickPaginator }.freeze

    define_method :pagy do |paginator = :offset, collection, **options|
      Pagy.const_get(paginators_map[paginator]).paginate(self, collection, **Pagy.options, **options)
    end
  end

  # Get the option values from the request/params
  module Get
    module_function

    # Get the hash of elements for the URL
    def hash_from(request) = request.instance_eval { { base_url:, path:, query_params: self.GET } }

    # Check the use of jsonapi and its consistency
    def jsonapi?(params, options)
      return false unless params[:page] && options[:jsonapi] # rubocop:disable Layout/EmptyLineAfterGuardClause
      params[:page].respond_to?(:fetch) || raise(JsonapiReservedParamError, params[:page])
    end

    # Get the page integer from the params
    def page_from(params, options, force_integer: true)
      page_sym = options[:page_sym] || DEFAULT[:page_sym]
      page     = jsonapi?(params, options) ? params[:page][page_sym] : params[page_sym]
      force_integer ? (page || 1).to_i : page
    end

    # Get the limit from the params
    def requested_limit_from(params, options)
      limit_sym = options[:limit_sym] || DEFAULT[:limit_sym]
      jsonapi?(params, options) ? params[:page][limit_sym] : params[limit_sym]
    end

    # Get the limit from the params, options or DEFAULT
    def limit_from(params, options)
      return options[:limit] || DEFAULT[:limit] \
      unless options[:requestable_limit] && (limit = requested_limit_from(params, options))

      [limit.to_i, options[:requestable_limit]].min
    end
  end
end
