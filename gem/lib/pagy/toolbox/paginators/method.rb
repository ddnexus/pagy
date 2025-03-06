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

  # Defines the pagy method. Include in the app controller/view.
  Method = Module.new do
             protected

             define_method :pagy do |paginator = :offset, collection, **options|
               Pagy.const_get(paginators[paginator]).paginate(self, collection, **Pagy.options, **options)
             end
           end
end
