# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/elasticsearch_rails
# encoding: utf-8
# frozen_string_literal: true

require 'pagy/extras/pagy_search'

class Pagy

  # used by the items extra
  ELASTICSEARCH_RAILS = true

  # create a Pagy object from an Elasticsearch::Model::Response::Response object
  def self.new_from_elasticsearch_rails(response, vars={})
    vars[:items] = response.search.options[:size] || 10
    vars[:page]  = (response.search.options[:from] || 0) / vars[:items] + 1
    total = if response.respond_to?(:raw_response)
      response.raw_response['hits']['total']
    else
      response.response['hits']['total']
    end
    vars[:count] = total.is_a?(Hash) ? total['value'] : total
    new(vars)
  end

  # Add specialized backend methods to paginate ElasticsearchRails searches
  module Backend ; private

    # Return Pagy object and items
    def pagy_elasticsearch_rails(pagy_search_args, vars={})
      model, search_args, _block, *called = pagy_search_args
      vars                   = pagy_elasticsearch_rails_get_vars(nil, vars)
      search_args[-1][:size] = vars[:items]
      search_args[-1][:from] = vars[:items] * (vars[:page] - 1)
      response               = model.search(*search_args)
      total                  = response.raw_response['hits']['total']
      vars[:count]           = total.is_a?(Hash) ? total['value'] : total
      pagy = Pagy.new(vars)
      # with :last_page overflow we need to re-run the method in order to get the hits
      if defined?(OVERFLOW) && pagy.overflow? && pagy.vars[:overflow] == :last_page
        return pagy_elasticsearch_rails(pagy_search_args, vars.merge(page: pagy.page))
      end
      return pagy, called.empty? ? response : response.send(*called)
    end

    # Sub-method called only by #pagy_elasticsearch_rails: here for easy customization of variables by overriding
    # the _collection argument is not available when the method is called
    def pagy_elasticsearch_rails_get_vars(_collection, vars)
      vars[:items] ||= VARS[:items]
      vars[:page]  ||= (params[ vars[:page_param] || VARS[:page_param] ] || 1).to_i
      vars
    end

  end
end
