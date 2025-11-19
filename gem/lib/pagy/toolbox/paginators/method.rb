# frozen_string_literal: true

require_relative '../../classes/request'

class Pagy
  paginators = { offset:              :OffsetPaginator,
                 countless:           :CountlessPaginator,
                 keyset:              :KeysetPaginator,
                 keynav_js:           :KeynavJsPaginator,
                 calendar:            :CalendarPaginator,
                 elasticsearch_rails: :ElasticsearchRailsPaginator,
                 meilisearch:         :MeilisearchPaginator,
                 searchkick:          :SearchkickPaginator }.freeze

  path = Pathname.new(__dir__)
  paginators.each { |symbol, name| autoload name, path.join(symbol.to_s) }

  # Pagy::Method defines the pagy method to be included in the app controller/view.
  Method = Module.new do
             protected

             define_method :pagy do |paginator = :offset, collection, **options|
               options[:root_key] = 'page' if options[:jsonapi] # enforce 'page' root_key for JSON:API
               options[:request]  = Request.new(options[:request] || request)
               arguments          = if paginator == :calendar
                                      [self, collection, options]
                                    else
                                      [collection, Pagy.options.merge(options)]
                                    end
               Pagy.const_get(paginators[paginator]).paginate(*arguments)
             end
           end
end
