# frozen_string_literal: true

class Pagy
  # Provide a ready to use pagy environment when included in irb/rails console
  module Console
    class Request
      attr_accessor :base_url, :path, :params

      def initialize
        @base_url = 'http://www.example.com'
        @path     = '/path'
        @params   = { example: '123' }
      end

      def GET = @params  # rubocop:disable Naming/MethodName

      def cookies = {}
    end

    class Collection < Array
      def initialize(arr = Array(1..1000))
        super
        @collection = clone
      end

      def offset(value) = tap { @collection = self[value..] }
      def limit(value)  = @collection[0, value]
      def count(*)      = size
    end

    include Method

    # Direct reference to request.params via a method
    def params     = request.params
    def request    = @request ||= Request.new
    def collection = Collection
  end
end
