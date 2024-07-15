# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/keyset
# frozen_string_literal: true

class Pagy
  class Keyset
    # Keyset adapter for ActiveRecord
    class ActiveRecord < Keyset
      protected

      # Get the keyset attributes of the record
      def latest_from(latest_record) = latest_record.slice(*@keyset.keys)

      # Extract the keyset from the set
      def extract_keyset
        @set.order_values.each_with_object({}) do |node, keyset|
          keyset[node.value.name.to_sym] = node.direction
        end
      end

      # Filter out the already retrieved records
      def after_latest = @set.where(after_latest_query, **@latest)

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
