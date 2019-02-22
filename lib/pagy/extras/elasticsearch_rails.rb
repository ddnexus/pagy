# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/elasticsearch_rails
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  # Add specialized backend methods to paginate ElasticsearchRails::Results
  module Backend ; private
    # Return Pagy object and items
    def pagy_elasticsearch_rails(results, vars={})
      pagy = Pagy.new(pagy_elasticsearch_rails_get_vars(results, vars))
      return pagy, results.offset(pagy.offset).limit(pagy.items)
    end

    # Sub-method called only by #pagy_elasticsearch_rails: here for easy customization of variables by overriding
    def pagy_elasticsearch_rails_get_vars(results, vars)
      vars[:count] ||= results.total
      vars[:page]  ||= params[:page] || 1
      vars
    end
  end
end
