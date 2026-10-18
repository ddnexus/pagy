# frozen_string_literal: true

class Pagy
  class Keyset
    module Adapters
      # Keyset adapter for ActiveRecord
      module ActiveRecord
        def extract_keyset
          @set.order_values.each_with_object({}) do |node, keyset|
            keyset[node.value.name.to_sym] ||= node.direction
          end
        end

        def keyset_attributes_from(record)
          record.slice(*@keyset.keys)
        end

        def quoted_identifiers(table)
          @set.model.connection_pool.with_connection do |connection|
            @keyset.to_h { |column| [column, "#{connection.quote_table_name(table)}.#{connection.quote_column_name(column)}"] }
          end
        end

        def typecast(attributes)
          model = @set.model
          {}.tap do |result|
            @keyset.each_key do |k|
              result[k] = model.type_for_attribute(k).cast(attributes[k])
            end
          end
        end

        def ensure_select
          return if @set.select_values.empty?

          @set = @set.select(*@keyset.keys)
        end

        def apply_where(predicate, arguments)
          @set = @set.where(predicate, **arguments)
        end

        def self.included(including)
          instance_methods(false).each do |method_name|
            including.send(:protected, method_name)
          end
        end
      end
    end
  end
end
