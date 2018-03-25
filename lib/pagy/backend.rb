# See Pagy::Backend API documentation: https://ddnexus.github.io/pagy/api/backend

class Pagy

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # returnthe pagy object and the scope of the page of records
    def pagy(obj, vars={})
      pagy = Pagy.new(count: pagy_get_count(obj), page: pagy_get_page, i18n_key: pagy_get_i18n_key(obj), **vars)
      return pagy, pagy_get_items(obj, pagy)
    end

    # get the collection count
    def pagy_get_count(obj)
      obj.count
    end

    # get the page number
    def pagy_get_page
      params[:page]
    end

    # get the i18n key for the collection
    def pagy_get_i18n_key(obj) end

    # get the page of records
    # this should work with ActiveRecord, Sequel, Mongoid...
    # override it if obj does not implement it that way
    def pagy_get_items(obj, pagy)
      obj.offset(pagy.offset).limit(pagy.items)
    end

  end
end
