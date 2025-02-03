# frozen_string_literal: true

class Pagy
  class Keyset
    module Adapters
      # Keyset adapter for ActiveRecord
      module ActiveRecord
        # Extract the keyset from the set
        def extract_keyset
          @set.order_values.each_with_object({}) do |node, keyset|
            keyset[node.value.name.to_sym] = node.direction
          end
        end

        # Get the keyset attributes from a record
        def keyset_attributes_from(record) = record.slice(*@keyset.keys)

        # Typecast the attributes
        def typecast(attributes)
          @set.model.new(attributes).slice(attributes.keys)
              .to_hash.transform_keys(&:to_sym)
        end

        # Append the missing keyset keys, if the set is restricted by select
        def ensure_select
          return if @set.select_values.empty?

          @set = @set.select(*@keyset.keys)
        end

        # Apply the where predicate to the set
        def apply_where(predicate, arguments)
          @set = @set.where(predicate, **arguments)
        end
      end
    end
  end
end
