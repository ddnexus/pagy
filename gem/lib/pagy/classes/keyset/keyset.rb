# frozen_string_literal: true

require 'json'
require_relative '../../modules/b64'

class Pagy
  # Implement wicked-fast keyset pagination for big data
  class Keyset < Pagy
    path = Pathname.new(__dir__)
    autoload :ActiveRecord, path.join('active_record')
    autoload :Sequel,       path.join('sequel')
    autoload :Keynav,       path.join('keynav')

    class TypeError < ::TypeError; end

    # Initialize Keyset* and Keyset::Keynav* classes and subclasses
    def self.new(set, **)
      # Subclass instances run only the initializer
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
      self.next
    end

    # Return the array of records for the current page
    def records
      @records ||= begin
                     ensure_select
                     fetch_records
                   end
    end

    # Return the next page (i.e. the cutoff of the current page)
    def next
      records
      return unless @more

      @next ||= B64.urlsafe_encode(extract_cutoff.to_json)
    end

    protected

    def keyset? = true

    def assign_page
      return unless (@page = @options[:page])

      @prior_cutoff = JSON.parse(B64.urlsafe_decode(@page))
    end

    def fetch_records
      apply_where(compose_predicate, arguments_from(@prior_cutoff)) if @prior_cutoff
      @set.limit(@limit + 1).to_a.tap do |records|
        @more = records.size > @limit && !records.pop.nil?
      end
    end

    # Compose the parameterized predicate used to extract the page records.
    #
    # For example: with a set like Pet.order(animal: :asc, name: :desc, id: :asc)
    # it returns a union of intersections:
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
    def compose_predicate(prefix = nil)
      operator    = { asc: '>', desc: '<' }
      directions  = @keyset.values
      table       = @set.model.table_name
      identifier  = @keyset.to_h { |column| [column, %("#{table}"."#{column}")] }
      placeholder = @keyset.to_h { |column| [column, ":#{prefix}#{column}"] }
      if @options[:tuple_comparison] && (directions.all?(:asc) || directions.all?(:desc))
        "(#{identifier.values.join(', ')}) #{operator[directions.first]} (#{placeholder.values.join(', ')})"
      else
        keyset = @keyset.to_a
        union  = []
        until keyset.empty?
          last_column, last_direction = keyset.pop
          intersection = +'('
          intersection << (keyset.map { |column, _d| "#{identifier[column]} = #{placeholder[column]}" } \
                            << "#{identifier[last_column]} #{operator[last_direction]} #{placeholder[last_column]}").join(' AND ')
          intersection << ')'
          union << intersection
        end
        union.join(' OR ')
      end
    end

    # Return the prefixed arguments from a cutoff
    def arguments_from(cutoff, prefix = nil)
      attributes = typecast(@keyset.keys.zip(cutoff).to_h)
      prefix ? attributes.transform_keys { |key| :"#{prefix}#{key}" } : attributes
    end

    # Extract the cutoff from the last record (only called if @more)
    def extract_cutoff
      attributes = keyset_attributes_from(@records.last)
      @options[:pre_serialize]&.(attributes)
      attributes.values
    end
  end
end
