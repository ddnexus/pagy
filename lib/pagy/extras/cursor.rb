require 'pagy/cursor'
class Pagy

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # Return Pagy object and items
    def pagy_cursor(collection, vars={}, options={})
      raise('ActiveRecord is not defined') unless defined?(ActiveRecord)
      pagy = Pagy::Cursor.new(pagy_cursor_get_vars(collection, vars))

      items =  pagy_cursor_get_items(collection, pagy, pagy.position)
      pagy.has_more =  pagy_cursor_has_more?(items, pagy)

      return pagy, items
    end

    def pagy_cursor_get_vars(collection, vars)
      vars[:arel_table] = collection.arel_table
      vars[:primary_key] = collection.primary_key
      vars[:backend] = 'sequence'
      vars
    end

    def pagy_cursor_get_items(collection, pagy, position=nil)
      if position.present?
        sql_comparation = pagy.arel_table[pagy.primary_key].send(pagy.comparation, position)
        collection.where(sql_comparation).reorder(pagy.order).limit(pagy.items)
      else
        collection.reorder(pagy.order).limit(pagy.items)
      end
    end

    def pagy_cursor_has_more?(collection, pagy)
      next_position = collection.last[pagy.primary_key]
      pagy_cursor_get_items(collection, pagy, next_position).exists?
    end
  end
end
