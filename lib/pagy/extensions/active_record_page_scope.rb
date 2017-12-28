class Pagy
  # include in any AR model to get the page(page, options={}) scope
  module ActiveRecordPageScope

    # USAGE: the :page_method_name scope (:page by defaul) must be the last one in the scope-chain
    # For example:
    # @results = MyModel.my_scope.my_other_scope.page(params[:page])
    # pagy_object = @results.pagy
    def self.included(model)
      scope_name = GlobalOptions.page_method_name || :page        # change the :page_method_name config option to customize

      model.scope scope_name, -> (page, options={}) {
        page      = page.to_i == 0 ? 1 : page.to_i                # page cleanup: params[:page] could be nil
        options   = GlobalOptions.to_h.merge(options).freeze      # merge and freeze the options
        count     = ActiveRecordHelpers.get_count(all, options)   # enable getting the count from cache if :use_rails_cache
        pagy      = Pagy.new(count, page, options)                # create the pagy object
        paginated = offset(pagy.offset).limit(pagy.limit)         # use #offset and #limit from the pagy object
        paginated.define_singleton_method(:pagy){ pagy }          # add the pagy object reader to the paginated collection
        paginated                                                 # return the enhanced paginated collection
      }
    end

  end

  # This is a collection of helpers not intended to extend your model, but intended to be used directly.
  # For example: Pagy::ActiveRecordHelpers.cache_key(scope)
  module ActiveRecordHelpers
    extend self

    # internal helper: it enables count-cacheing if the :count_cache option is set to:
    # :rails_cache - use the rails_cache (in that case you can also set the cache_expires_in)
    # Proc object  - useful if you want to handle the cache directly:
    #                it calls the proc passing scope and options to get the count
    # Otherwise it doesn't use any cache and performs a count query at each pagination
    def get_count(scope, options)

      case options[:count_cache]

        when :rails_cache
          expires_in = options[:cache_expires_in] || 10.minutes
          Rails.cache.fetch(cache_key(scope), expires_in: expires_in) do
            scope.count
          end

        when Proc then options[:count_cache].call(scope, options)

        else scope.count

      end
    end

    # helper for standard pagy cache key
    def cache_key(scope)
      "pagy>#{scope.model}>:#{scope.to_sql}"
    end

    # helper useful if you use ActiveSupport::Cache::MemoryStore rails cache
    # you should use it in a after_save callback in your model
    # in order to delete the cache of your model
    # after_save { Pagy::ActiveRecordHelpers.delete_memory_store_cache(self)}
    def delete_memory_store_cache(model)
      Rails.cache.delete_matched /^pagy>#{model}>:/
    end

  end

end
