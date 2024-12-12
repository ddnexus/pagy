# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/keyset
# frozen_string_literal: true

class Pagy
  class Keyset
    # Keyset adapter for sequel
    module SequelAdapter
      # Append the missing keyset keys if the set is restricted by select
      def apply_select
        selected = @set.opts[:select]
        @set.select_append(*@keyset.keys.reject { |c| selected.include?(c) })
      end

      # Extract the keyset from the set
      def extract_keyset
        return {} unless @set.opts[:order]

        @set.opts[:order].each_with_object({}) do |item, keyset|
          case item
          when Symbol
            keyset[item] = :asc
          when ::Sequel::SQL::OrderedExpression
            keyset[item.expression] = item.descending ? :desc : :asc
          else
            raise TypeError, "#{item.class.inspect} is not a supported Sequel::SQL::OrderedExpression"
          end
        end
      end

      # Filter the page records
      def filter_records = @set.where(::Sequel.lit(beyond_cutoff_sql, **@cutoff_args))

      # Get the keyset attributes from the record
      def keyset_attributes_from(record) = record.to_hash.slice(*@keyset.keys)

      # Set with selected columns?
      def select? = !@set.opts[:select].nil?

      # Typecast the cutoff args
      def typecast_args(args)
        model = @set.opts[:model]
        model.unrestrict_primary_key if (restricted_pk = model.restrict_primary_key?)
        args = model.new(args).to_hash.slice(*args.keys.map(&:to_sym))
        model.restrict_primary_key if restricted_pk
        args
      end
    end
  end
end
