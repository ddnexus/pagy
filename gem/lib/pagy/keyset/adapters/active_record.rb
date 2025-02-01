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

        # Apply the filtering where clause
        def filtered = @set.where(sql_filter, **@filter)

        # Get the keyset attributes from the record
        def keyset_attributes_from(record) = record.slice(*@keyset.keys)

        # Set with selected columns?
        def select? = !@set.select_values.empty?

        # Append the missing keyset keys if the set is restricted by select
        def selected = @set.select(*@keyset.keys)

        # Typecast the attributes
        def typecast(attributes)
          @set.model.new(attributes).slice(attributes.keys)
              .to_hash.transform_keys(&:to_sym)
        end
      end
    end
  end
end
