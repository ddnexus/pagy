# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/elasticsearch-rails

class Pagy
  # Add specialized backend methods to paginate ElasticsearchRails::Results
  module Backend ; private
    # Return Pagy object and items
    def pagy_elasticsearch_rails(results, vars={})
      pagy = Pagy.new(pagy_elasticsearch_rails_get_vars(results, vars))
      return pagy, results.offset(pagy.offset).limit(pagy.items)
    end

    def pagy_elasticsearch_rails_get_vars(results, vars)
      # Return the merged variables to initialize the Pagy object
      { count: results.total,
        page: (params[:page] || 1)}.merge!(vars)
    end
  end
end
