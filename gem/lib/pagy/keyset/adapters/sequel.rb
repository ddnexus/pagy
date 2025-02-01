# frozen_string_literal: true

class Pagy
  class Keyset
    module Adapters
      # Keyset adapter for sequel
      module Sequel
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

        # Apply the filtering where clause
        def filtered = @set.where(::Sequel.lit(sql_filter, **@filter))

        # Get the keyset attributes from the record
        def keyset_attributes_from(record) = record.to_hash.slice(*@keyset.keys)

        # Set with selected columns?
        def select? = !@set.opts[:select].nil?

        # Append the missing keyset keys if the set is restricted by select
        def selected
          selected = @set.opts[:select]
          @set.select_append(*@keyset.keys.reject { |c| selected.include?(c) })
        end

        # Typecast the attributes
        def typecast(attributes)
          model = @set.opts[:model]
          model.unrestrict_primary_key if (restricted_pk = model.restrict_primary_key?)
          attributes = model.new(attributes).to_hash.slice(*attributes.keys.map(&:to_sym))
          model.restrict_primary_key if restricted_pk
          attributes
        end
      end
    end
  end
end
