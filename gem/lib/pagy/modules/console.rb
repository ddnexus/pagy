# frozen_string_literal: true

class Pagy
  # Provide a ready to use pagy environment when included in irb/rails console
  module Console
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
    def request    = @request ||= { base_url: 'http://www.example.com', path: '/path', params: { example: '123' } }
    def params     = request[:params]
    def collection = Collection
  end
end
