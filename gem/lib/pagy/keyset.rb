# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/keyset
# frozen_string_literal: true

require 'json'
require_relative 'b64'
require_relative 'shared_methods'

class Pagy
  # Implement wicked-fast keyset pagination for big data
  class Keyset
    class TypeError < ::TypeError; end

    include SharedMethods

    # Pick the right adapter for the set
    def self.new(set, **vars)
      if self == Pagy::Keyset
        if defined?(::ActiveRecord) && set.is_a?(::ActiveRecord::Relation)
          ActiveRecord
        elsif defined?(::Sequel) && set.is_a?(::Sequel::Dataset)
          Sequel
        else
          raise TypeError, "expected set to be an instance of ActiveRecord::Relation or Sequel::Dataset; got #{set.class}"
        end.new(set, **vars)
      else
        allocate.tap { |instance| instance.send(:initialize, set, **vars) }
      end
    end

    attr_reader :latest  # Other readers from SharedMethods

    def initialize(set, **vars)
      default = DEFAULT.slice(:limit, :page_param,                    # from pagy
                              :headers,                               # from headers extra
                              :jsonapi,                               # from jsonapi extra
                              :limit_param, :limit_max, :limit_extra) # from limit_extra
      assign_vars({ **default, page: nil }, vars)
      assign_limit
      @set    = set
      @page   = @vars[:page]
      @keyset = extract_keyset
      raise InternalError, 'the set must be ordered' if @keyset.empty?
      return unless @page

      latest  = JSON.parse(B64.urlsafe_decode(@page)).transform_keys(&:to_sym)
      @latest = typecast_latest(latest)
      raise InternalError, 'page and keyset are not consistent' \
            unless @latest.keys == @keyset.keys
    end

    # Return the next page
    def next
      records
      return unless @more

      @next ||= begin
                  hash = keyset_attributes_from(@records.last)
                  json = @vars[:jsonify_keyset_attributes]&.(hash) || hash.to_json
                  B64.urlsafe_encode(json)
                end
    end

    # Fetch the array of records for the current page
    def records
      @records ||= begin
                     @set = apply_select if select?
                     if @latest
                       # :nocov:
                       @set = @vars[:after_latest]&.(@set, @latest) || # deprecated
                              # :nocov:
                              @vars[:filter_newest]&.(@set, @latest, @keyset) ||
                              filter_newest
                     end
                     records = @set.limit(@limit + 1).to_a
                     @more   = records.size > @limit && !records.pop.nil?
                     records
                   end
    end

    protected

    # Prepare the literal query string (complete with the placeholders for value interpolation)
    # used to filter the newest records.
    # For example:
    # With a set like Pet.order(animal: :asc, name: :desc, id: :asc) it returns the following string:
    # ( "pets"."animal" = :animal AND "pets"."name" = :name AND "pets"."id" > :id ) OR
    # ( "pets"."animal" = :animal AND "pets"."name" < :name ) OR
    # ( "pets"."animal" > :animal )
    # When :tuple_comparison is enabled, and if the order is all :asc or all :desc,
    # with a set like Pet.order(:animal, :name, :id) it returns the following string:
    # ( "pets"."animal", "pets"."name", "pets"."id" ) > ( :animal, :name, :id )
    def filter_newest_query
      operator = { asc: '>', desc: '<' }
      directions = @keyset.values
      name = quoted_identifiers(@set.model.table_name)

      if @vars[:tuple_comparison] && (directions.all?(:asc) || directions.all?(:desc))
        placeholders = @keyset.keys.map { |column| ":#{column}" }.join(', ')
        "( #{name.values.join(', ')} ) #{operator[directions.first]} ( #{placeholders} )"
      else
        keyset = @keyset.to_a
        where  = []
        until keyset.empty?
          last_column, last_direction = keyset.pop
          query = +'( '
          query << (keyset.map { |column, _d| "#{name[column]} = :#{column}" } \
                    << "#{name[last_column]} #{operator[last_direction]} :#{last_column}").join(' AND ')
          query << ' )'
          where << query
        end
        where.join(' OR ')
      end
    end
  end
end

require_relative 'keyset/active_record'
require_relative 'keyset/sequel'
