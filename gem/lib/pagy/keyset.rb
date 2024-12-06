# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/keyset
# frozen_string_literal: true

require 'json'
require_relative 'b64'
require_relative 'shared_methods'
require_relative 'keyset/active_record_adapter'
require_relative 'keyset/sequel_adapter'

class Pagy
  # Implement wicked-fast keyset pagination for big data
  class Keyset
    class TypeError < ::TypeError; end

    class ActiveRecord < Keyset
      include ActiveRecordAdapter
    end

    class Sequel < Keyset
      include SequelAdapter
    end

    # Pick the right adapter for the set
    def self.new(set, **vars)
      if self == Pagy::Keyset || (defined?(Cached) && self == Pagy::Keyset::Cached)
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

    include SharedMethods

    def initialize(set, **vars)
      assign_vars(default, vars)
      assign_limit
      @set    = set
      @keyset = extract_keyset
      raise InternalError, 'the set must be ordered' if @keyset.empty?

      assign_page
      setup_cache # Only used by Keyset::Cached (called here to avoid overriding)
      assign_cursor
      assign_query_params
    end

    # Assign the cursor from the cache
    def assign_cursor
      @cursor = @vars[:page]
    end

    # Assign the page
    def assign_page
      @page = @vars[:page]
    end

    # Assign the query_params
    def assign_query_params
      return unless @cursor

      @query_params = cursor_to_query_params(@cursor)
    end

    # Decode a cursor, check its consistency and returns the query params
    def cursor_to_query_params(cursor, prefix = nil)
      identifier = JSON.parse(B64.urlsafe_decode(cursor)).transform_keys(&:to_sym)
      raise InternalError, 'cursor and keyset are not consistent' \
      unless identifier.keys == @keyset.keys

      params = typecast_latest(identifier)
      prefix ? params.transform_keys { |key| :"#{prefix}#{key}" } : params
    end

    # Return the Keyset default variables
    def default
      default = DEFAULT.slice(:limit, :page_param,                    # from pagy
                              :headers,                               # from headers extra
                              :jsonapi,                               # from jsonapi extra
                              :limit_param, :limit_max, :limit_extra) # from limit_extra
      { **default, page: nil }
    end

    # Get the records and set the @more
    def fetch_records
      records = @set.limit(@limit + 1).to_a
      @more   = records.size > @limit && !records.pop.nil?
      records
    end

    # Prepare the literal query string (complete with the placeholders for value interpolation)
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
    def filter_records_query(prefix = nil)
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

    # Return the next page
    def next
      records
      return unless @more

      @next ||= next_cursor
    end

    # Return the next cursor
    def next_cursor
      hash = keyset_attributes_from(@records.last)
      json = @vars[:jsonify_keyset_attributes]&.(hash) || hash.to_json
      B64.urlsafe_encode(json)
    end

    # Fetch the array of records for the current page
    def records
      @records ||= begin
                     @set = apply_select if select?
                     if @query_params
                       # :nocov:
                       @set = @vars[:after_latest]&.(@set, @query_params)            ||  # deprecated
                              @vars[:filter_newest]&.(@set, @query_params, @keyset)  ||  # deprecated
                              @vars[:filter_records]&.(@set, @query_params, @keyset) ||
                              # :nocov:
                              filter_records
                     end
                     fetch_records
                   end
    end

    # Only implemented in Keyset::Cached
    def setup_cache; end
  end
end
