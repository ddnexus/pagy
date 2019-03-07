class Pagy

  attr_reader :before, :after, :arel_table, :primary_key, :order, :comparation, :position
  attr_accessor :has_more
  alias_method :has_more?, :has_more

  def initialize(vars)
    @vars = VARS.merge(vars.delete_if{|_,v| v.nil? || v == '' })
    @items = vars[:items] || VARS[:items]
    @before = vars[:before]
    @after = vars[:after]
    @arel_table = vars[:arel_table]
    @primary_key = vars[:primary_key]

    if @before.present? and @after.present?
      raise(ArgumentError, 'before and after can not be both mentioned')
    end
    if @before.present?
      @comparation = 'lt'
      @position = @before
      @order = { @primary_key => :desc }
    end

    if @after.present?
      @comparation = 'gt'
      @position = @after
      @order = { @primary_key => :asc }
    end
  end

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # Return Pagy object and items
    def pagy_cursor(collection, vars={}, options={})
      raise('ActiveRecord is not defined') unless defined?(ActiveRecord)
      pagy = Pagy.new(pagy_array_get_vars(collection, vars))

      items =  pagy_cursor_get_items(collection, pagy, pagy.position)
      pagy.has_more =  pagy_cursor_has_more?(items, pagy)

      return pagy, items
    end

    def pagy_array_get_vars(collection, vars)
      vars[:arel_table] = collection.arel_table
      vars[:primary_key] = collection.primary_key
      vars
    end

    def pagy_cursor_get_items(collection, pagy, position)
      sql_comparation = pagy.arel_table[pagy.primary_key].send(pagy.comparation, position)
      collection.where(sql_comparation).reorder(pagy.order).limit(pagy.items)
    end

    def pagy_cursor_has_more?(collection, pagy)
      next_position = collection.last[pagy.primary_key]
      pagy_cursor_get_items(collection, pagy, next_position).exists?
    end
  end
end
