# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/keyset
# frozen_string_literal: true

class Pagy
  class Keyset
    # Keyset adapter for ActiveRecord
    module ActiveRecordAdapter
      # Append the missing keyset keys if the set is restricted by select
      def apply_select
        @set.select(*@keyset.keys)
      end

      # Extract the keyset from the set
      def extract_keyset
        @set.order_values.each_with_object({}) do |node, keyset|
          keyset[node.value.name.to_sym] = node.direction
        end
      end

      # Filter the page records
      def filter_records = @set.where(filter_records_sql, **@filter_args)

      # Get the keyset attributes from the record
      def keyset_attributes_from(record) = record.slice(*@keyset.keys)

      # Set with selected columns?
      def select? = !@set.select_values.empty?

      # Typecast the latest attributes
      def typecast_args(args)
        @set.model.new(args).slice(args.keys)
            .to_hash.transform_keys(&:to_sym)
      end
    end
  end
end
