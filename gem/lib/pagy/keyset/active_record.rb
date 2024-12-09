# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/keyset
# frozen_string_literal: true

class Pagy
  class Keyset
    # Keyset adapter for ActiveRecord
    class ActiveRecord < Keyset
      protected

      # Get the keyset attributes from the record
      def keyset_attributes_from(record) = record.slice(*@keyset.keys)

      # Extract the keyset from the set
      def extract_keyset
        @set.order_values.each_with_object({}) do |node, keyset|
          keyset[node.value.name.to_sym] = node.direction
        end
      end

      # Filter the newest records
      def filter_newest = @set.where(filter_newest_query, **@latest)

      # Filter the oldest records
      def filter_oldest = @set.reverse_order.where(filter_newest_query, **@previous)

      # Append the missing keyset keys if the set is restricted by select
      def apply_select
        @set.select(*@keyset.keys)
      end

      # Set with selected columns?
      def select? = !@set.select_values.empty?

      # Typecast the latest attributes
      def typecast_latest(latest)
        @set.model.new(latest).slice(latest.keys)
            .to_hash.transform_keys(&:to_sym)
      end
    end
  end
end
