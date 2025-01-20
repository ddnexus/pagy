# frozen_string_literal: true

require_relative '../pagy'  # so you can require just the extra in the console

class Pagy
  # Provide a ready to use pagy environment when included in irb/rails console
  module Console
    # Include Backend, Frontend and set the default URL
    def self.included(main)
      main.include(Backend)
      main.include(Frontend)
      main.define_method(:params) { {} }
      # :nocov:
      main.define_method(:default_request) do
        { request: { url_prefix: 'http://www.example.com/subdir',
          query_params: { example: '123' } } }
      end
      # :nocov:
    end

    # Require the extras passed as arguments
    def pagy_extras(*extras)
      extras.each { |extra| require "pagy/extras/#{extra}" }
      puts "Required extras: #{extras.map(&:inspect).join(', ')}"
    end
  end
end
