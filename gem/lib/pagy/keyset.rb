# frozen_string_literal: true

require 'json'
require_relative 'modules/b64'

class Pagy
  # Implement wicked-fast keyset pagination for big data
  class Keyset < Pagy
    autoload :ActiveRecord, PAGY_PATH.join('keyset/active_record')
    autoload :Sequel,       PAGY_PATH.join('keyset/sequel')
    autoload :Keynav,       PAGY_PATH.join('keyset/keynav')

    class TypeError < ::TypeError; end

    # Allow to run Keyset.new or Keyset::ActiveRecord.new or Keyset::Sequel.new
    def self.new(set, **)
      # A subclass instance runs only the initializer
      if /::(?:ActiveRecord|Sequel)$/.match?(name)  # check without triggering autoload
        return allocate.tap { |instance| instance.send(:initialize, set, **) }
      end

      subclass = if defined?(::ActiveRecord) && set.is_a?(::ActiveRecord::Relation)
                   self::ActiveRecord
                 elsif defined?(::Sequel) && set.is_a?(::Sequel::Dataset)
                   self::Sequel
                 else
                   raise TypeError, "expected an ActiveRecord::Relation or Sequel::Dataset; got #{set.class}"
                 end
      subclass.new(set, **)
    end

    def initialize(set, **) # rubocop:disable Lint/MissingSuper
      assign_options(**)
      assign_and_check(limit: 1)
      @set    = set
      @keyset = @options[:keyset] || extract_keyset
      raise InternalError, 'the set must be ordered' if @keyset.empty?

      assign_page
      assign_filter
    end

    # Assign the filter_args
    def assign_filter
      return unless @prior_cutoff

      @filter = filter_for(@prior_cutoff)
    end

    # Assign the page
    def assign_page
      return unless (@page = @options[:page])

      @prior_cutoff = JSON.parse(B64.urlsafe_decode(@page))
    end

    # Derive the cutoff from the last record
    def derive_cutoff
      attr = keyset_attributes_from(@records.last)
      (@options[:stringify_keyset_values]&.(attr) || attr).values
    end

    # Fetch the records and set the @more flag
    def fetch_records
      @set.limit(@limit + 1).to_a.tap do |records|
        @more = records.size > @limit && !records.pop.nil?
      end
    end

    # Return the filter for a cutoff
    def filter_for(cutoff, prefix = nil)
      attributes = typecast(@keyset.keys.zip(cutoff).to_h)
      prefix ? attributes.transform_keys { |key| :"#{prefix}#{key}" } : attributes
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
                     @set = selected if select?
                     @set = filtered if @filter
                     fetch_records
                   end
    end

    # Prepare the literal SQL filter (complete with the placeholders for value interpolation)
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
    def sql_filter(prefix = nil)   # prefix is used by the Keyset::Keynav instances
      operator    = { asc: '>', desc: '<' }
      directions  = @keyset.values
      table       = @set.model.table_name
      identifier  = @keyset.to_h { |column| [column, %("#{table}"."#{column}")] }
      placeholder = @keyset.to_h { |column| [column, ":#{prefix}#{column}"] }
      if @options[:tuple_comparison] && (directions.all?(:asc) || directions.all?(:desc))
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
  end
end
