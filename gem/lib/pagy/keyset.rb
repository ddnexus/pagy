# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/keyset
# frozen_string_literal: true

require 'json'
require_relative 'b64'

require_relative 'keyset/adapters/active_record'
require_relative 'keyset/adapters/sequel'

class Pagy
  # Implement wicked-fast keyset pagination for big data
  class Keyset < Pagy

    autoload :Augmented, 'pagy/keyset/augmented'

    class TypeError < ::TypeError; end

    class ActiveRecord < Keyset
      include Adapters::ActiveRecord
    end

    class Sequel < Keyset
      include Adapters::Sequel
    end

    # Pick the right adapter for the set and initilize the right class
    def self.new(set, **vars)
      if self == Pagy::Keyset || (defined?(::Pagy::Keyset::Augmented) && self == ::Pagy::Keyset::Augmented)
        if defined?(::ActiveRecord) && set.is_a?(::ActiveRecord::Relation)
          self::ActiveRecord
        elsif defined?(::Sequel) && set.is_a?(::Sequel::Dataset)
          self::Sequel
        else
          raise TypeError, "expected set to be an instance of ActiveRecord::Relation or Sequel::Dataset; got #{set.class}"
        end.new(set, **vars)
      else
        allocate.tap { |instance| instance.send(:initialize, set, **vars) }
      end
    end

    def initialize(set, **vars) # rubocop:disable Lint/MissingSuper
      assign_vars(vars)
      assign_limit
      @set    = set
      @keyset = vars[:keyset] || extract_keyset
      raise InternalError, 'the set must be ordered' if @keyset.empty?

      assign_page
      assign_filter_args
    end

    # Assign the filter_args
    def assign_filter_args
      return unless @prev_cutoff

      @filter_args = filter_args_for(@prev_cutoff)
    end

    # Assign the page
    def assign_page
      @page        = @vars[:page]
      @prev_cutoff = JSON.parse(B64.urlsafe_decode(@page)) if @page
    end

    # Prepare the literal SQL string (complete with the placeholders for value interpolation)
    # used to filter the page records. For example:
    #
    # With a set like Pet.order(animal: :asc, name: :desc, id: :asc) it returns the following string:
    #
    #    ("pets"."animal" = :animal AND "pets"."name" = :name AND "pets"."id" > :id) OR
    #    ("pets"."animal" = :animal AND "pets"."name" < :name) OR
    #    ("pets"."animal" > :animal)
    #
    # When :tuple_comparison is enabled, and if the order is all :asc or all :desc,
    # with a set like Pet.order(:animal, :name, :id) it returns the following string:
    #
    #     ("pets"."animal", "pets"."name", "pets"."id") > (:animal, :name, :id)
    #
    def after_cutoff_sql(prefix = nil)   # prefix is used by the Keyset::Augmented instances
      operator    = { asc: '>', desc: '<' }
      directions  = @keyset.values
      table       = @set.model.table_name
      identifier  = @keyset.to_h { |column| [column, %("#{table}"."#{column}")] }
      placeholder = @keyset.to_h { |column| [column, ":#{prefix}#{column}"] }
      if @vars[:tuple_comparison] && (directions.all?(:asc) || directions.all?(:desc))
        "(#{identifier.values.join(', ')}) #{operator[directions.first]} (#{placeholder.values.join(', ')})"
      else
        keyset = @keyset.to_a
        where  = []
        until keyset.empty?
          last_column, last_direction = keyset.pop
          query = +'('
          query << (keyset.map { |column, _d| "#{identifier[column]} = #{placeholder[column]}" } \
                     << "#{identifier[last_column]} #{operator[last_direction]} #{placeholder[last_column]}").join(' AND ')
          query << ')'
          where << query
        end
        where.join(' OR ')
      end
    end

    # Derive the cutoff from the last record
    def derive_cutoff
      attr = keyset_attributes_from(@records.last)
      (@vars[:stringify_keyset_values]&.(attr) || attr).values
    end

    # Fetch the records and set the @more flag
    def fetch_records
      records = @set.limit(@limit + 1).to_a
      @more   = records.size > @limit && !records.pop.nil?
      records
    end

    # Return the filter arguments for a cutoff
    def filter_args_for(cutoff)
      args = @keyset.keys.zip(cutoff).to_h
      typecast_args(args)
    end

    # Return the next page (i.e. the cutoff of the current page)
    def next
      records
      return unless @more

      @next ||= B64.urlsafe_encode(derive_cutoff.to_json)
    end

    # Fetch the array of records for the current page
    def records
      @records ||= begin
                     @set = apply_select if select?
                     @set = filter_records if @filter_args
                     fetch_records
                   end
    end
  end
end
