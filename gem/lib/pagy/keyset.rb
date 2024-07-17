# See Pagy API documentation: https://ddnexus.github.io/pagy/docs/api/keyset
# frozen_string_literal: true

require 'json'
require_relative 'b64'

class Pagy
  # Implement wicked-fast keyset pagination for big data
  class Keyset
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
      @latest = @vars[:typecast_latest]&.(latest) || typecast_latest(latest)
      raise InternalError, 'page and keyset are not consistent' \
            unless @latest.keys == @keyset.keys
    end

    # Return the next page
    def next
      records
      return unless @more

      @next ||= B64.urlsafe_encode(latest_from(@records.last).to_json)
    end

    # Retrieve the array of records for the current page
    def records
      @records ||= begin
        @set    = apply_select if select?
        @set    = @vars[:after_latest]&.(@set, @latest) || after_latest if @latest
        records = @set.limit(@limit + 1).to_a
        @more   = records.size > @limit && !records.pop.nil?
        records
      end
    end

    protected

    # Prepare the literal query to filter out the already retrieved records
    def after_latest_query
      operator   = { asc: '>', desc: '<' }
      directions = @keyset.values
      if @vars[:row_comparison] && (directions.all?(:asc) || directions.all?(:desc))
        # Row comparison: works for same directions keysets
        # Use B-tree index for performance
        columns      = @keyset.keys
        placeholders = columns.map { |column| ":#{column}" }.join(', ')
        "( #{columns.join(', ')} ) #{operator[directions.first]} ( #{placeholders} )"
      else
        # Generic comparison: works for keysets ordered in mixed or same directions
        keyset = @keyset.to_a
        where  = []
        until keyset.empty?
          last_column, last_direction = keyset.pop
          query = +'( '
          query << (keyset.map { |column, _d| "#{column} = :#{column}" } \
                    << "#{last_column} #{operator[last_direction]} :#{last_column}").join(' AND ')
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
