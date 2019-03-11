require 'pagy/cursor'
class Pagy

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # Return Pagy object and items
    def pagy_uuid_cursor(collection, vars={})
      raise('ActiveRecord is not defined') unless defined?(ActiveRecord)
      pagy = Pagy::Cursor.new(pagy_uuid_cursor_get_vars(collection, vars))
      items =  pagy_uuid_cursor_get_items(collection, pagy, pagy.position)
      pagy.has_more =  pagy_uuid_cursor_has_more?(items, pagy)

      return pagy, items
    end

    def pagy_uuid_cursor_get_vars(collection, vars)
      vars[:arel_table] = collection.arel_table
      vars[:primary_key] = collection.primary_key
      vars[:backend] = 'uuid'
      vars
    end

    def pagy_uuid_cursor_get_items(collection, pagy, position=nil)
      if position.present?
        arel_table = pagy.arel_table

        select_created_at = arel_table.project(arel_table[:created_at]).where(arel_table[pagy.primary_key].eq(position))
        select_the_sample_created_at = arel_table[:created_at].eq(select_created_at).and(arel_table[pagy.primary_key].send(pagy.comparation, position))
        sql_comparation = arel_table[:created_at].send(pagy.comparation, select_created_at).or(select_the_sample_created_at)

        collection = collection.where(sql_comparation)
      end
      collection.reorder(pagy.order).limit(pagy.items)
    end

    def pagy_uuid_cursor_has_more?(collection, pagy)
      next_position = collection.last[pagy.primary_key]
      pagy_uuid_cursor_get_items(collection, pagy, next_position).exists?
    end
  end
end
