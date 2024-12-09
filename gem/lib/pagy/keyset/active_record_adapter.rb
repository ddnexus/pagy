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
      def filter_records = @set.where(filter_records_sql, **@filter_params)

      # Get the keyset attributes from the record
      def keyset_attributes_from(record) = record.slice(*@keyset.keys)

      # Set with selected columns?
      def select? = !@set.select_values.empty?

      # Get a standard string omitting the statements that don't affect the paginated records
      # TODO: Check for other statements
      def sql_for_key = @set.only(:order, :where, :group, :having).to_sql

      # Typecast the latest attributes
      def typecast_params(latest)
        @set.model.new(latest).slice(latest.keys)
            .to_hash.transform_keys(&:to_sym)
      end
    end
  end
end
