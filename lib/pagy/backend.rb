class Pagy

  # Including this module (usually in your controller) is handy but totally optional.
  # It basically just encapsulates a couple of verbose statements in one single slick
  # #pagy method, but it does not add any functionality on its own.
  #
  # Using the module allows you to have a predefined method and a few sub-methods
  # (i.e. methods called only by the predefined method) handy if you need to override
  # some aspect of the predefined #pagy method.
  #
  # However, you can just explicitly write your own pagy method in just a couple of
  # lines, specially if you need to override two or more methods. For example:
  #
  # def pagy(scope, opts={})
  #   pagy = Pagy.new scope.count, page: params[:page], **opts
  #   return pagy, scope.offset(pagy.offset).limit(pagy.items)
  # end

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    def pagy(obj, opts={})
      pagy = Pagy.new(count: pagy_get_count(obj), page: pagy_get_page, i18n_key: pagy_get_i18n_key(obj), **opts)
      return pagy, pagy_get_items(obj, pagy)
    end

    def pagy_get_count(obj)
      obj.count
    end

    def pagy_get_page
      params[:page]
    end

    def pagy_get_i18n_key(obj) end

    # this should work with ActiveRecord, Sequel, Mongoid...
    # override it if obj does not implement it that way
    def pagy_get_items(obj, pagy)
      obj.offset(pagy.offset).limit(pagy.items)
    end

  end
end
