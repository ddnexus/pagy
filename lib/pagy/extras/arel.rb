# See the Pagy documentation: https://ddnexus.github.io/pagy/extras/array
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  module Backend ; private

    def pagy_arel(collection, vars={})
      pagy = Pagy.new(pagy_arel_get_vars(collection, vars))
      return pagy, pagy_get_items(collection, pagy)
    end

    def pagy_arel_get_vars(collection, vars)
      vars[:count] ||= pagy_arel_count(collection)
      vars[:page]  ||= params[ vars[:page_param] || VARS[:page_param] ]
      vars
    end

    def pagy_arel_count(collection)
      if collection.group_values.empty?
        # COUNT(*)
        collection.count(:all)
      else
        # COUNT(*) OVER ()
        sql = Arel.star.count.over(Arel::Nodes::Grouping.new([]))
        collection.unscope(:order).limit(1).pluck(sql).first
      end
    end

  end
end
