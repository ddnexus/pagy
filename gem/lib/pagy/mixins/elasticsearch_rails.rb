# See the Pagy documentation: https://ddnexus.github.io/pagy/docs/extras/elasticsearch_rails
# frozen_string_literal: true

require_relative '../offset/elasticsearch_rails'

class Pagy
  # Model extension
  module ElasticsearchRails # :nodoc:
    # Return an array used to delay the call of #search
    # after the pagination variables are merged to the options.
    # It also pushes to the same array an optional method call.
    def pagy_elasticsearch_rails(query_or_payload, **options)
      [self, query_or_payload, options].tap do |args|
        args.define_singleton_method(:method_missing) { |*a| args += a }
      end
    end
    alias_method Offset::ElasticsearchRails::DEFAULT[:elasticsearch_rails_pagy_search], :pagy_elasticsearch_rails
  end

  # Add specialized backend methods to paginate ElasticsearchRails searches
  Backend.class_eval do
    private

    # Return Pagy object and records
    def pagy_elasticsearch_rails(pagy_search_args, **vars)
      vars[:page]  ||= pagy_get_page(vars)
      vars[:limit] ||= pagy_get_limit(vars)
      model, query_or_payload, options, *called = pagy_search_args
      options[:size] = vars[:limit]
      options[:from] = vars[:limit] * ((vars[:page] || 1) - 1)
      response       = model.send(Offset::ElasticsearchRails::DEFAULT[:elasticsearch_rails_search], query_or_payload, **options)
      vars[:count]   = Offset::ElasticsearchRails.total_count(response)
      pagy           = Offset.new(**vars)
      # with :last_page overflow we need to re-run the method in order to get the hits
      if pagy.overflow? && pagy.vars[:overflow] == :last_page
        return pagy_elasticsearch_rails(pagy_search_args, **vars, page: pagy.page)
      end

      [pagy, called.empty? ? response : response.send(*called)]
    end
  end
end
