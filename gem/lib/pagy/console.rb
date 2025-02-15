# frozen_string_literal: true

require_relative '../pagy'  # so you can require just the extra in the console

class Pagy
  # Provide a ready to use pagy environment when included in irb/rails console
  module Console
    class Request
      attr_accessor :url_base, :path, :params

      def initialize
        @url_base = 'http://www.example.com'
        @path     = '/path'
        @params   = { example: '123' }
      end

      def GET = @params  # rubocop:disable Naming/MethodName
    end

    class Collection < Array
      def initialize(arr = Array(1..1000))
        super
        @collection = clone
      end

      def offset(value)
        @collection = self[value..]
        self
      end

      def limit(value)
        @collection[0, value]
      end

      def count(*)
        size
      end
    end

    include Paginators

    # Direct reference to request.params via a method
    def params
      request.params
    end

    def request
      @request ||= Request.new
    end

    def collection
      Collection
    end
  end
end
