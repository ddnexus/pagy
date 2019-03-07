class Pagy

  attr_reader :before, :after, :arel_table, :primary_key, :order

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


    @order = { @primary_key => :desc } if @before.present?
    @order = { @primary_key => :asc } if @after.present?
  end

  module Backend ; private         # the whole module is private so no problem with including it in a controller

    # Return Pagy object and items
    def pagy_cursor(collection, vars={}, options={})
      raise('ActiveRecord is not defined') unless defined?(ActiveRecord)
      pagy = Pagy.new(pagy_array_get_vars(collection, vars))
      return pagy, pagy_cursor_get_items(collection, pagy)
    end

    def pagy_array_get_vars(collection, vars)
      vars[:arel_table] = collection.arel_table
      vars[:primary_key] = collection.primary_key
      vars
    end

    # Sub-method called only by #pagy: here for easy customization of record-extraction by overriding
    def pagy_cursor_get_items(collection, pagy)
      # This should work with ActiveRecord
      records = collection
      records = pagy_cursor_before(records, pagy)  if pagy.before.present?
      records = pagy_cursor_after(records, pagy) if pagy.after.present?
      records.limit(pagy.items)
    end

    def pagy_cursor_before(collection, pagy)
      # This should work with ActiveRecord
      collection.where(pagy.arel_table[pagy.primary_key].lt(pagy.before)).reorder(pagy.order)
    end

    def pagy_cursor_after(collection, pagy)
      # This should work with ActiveRecord
      collection.where(pagy.arel_table[pagy.primary_key].gt(pagy.after)).reorder(pagy.order)
    end
  end
end
