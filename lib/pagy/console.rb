# See Pagy::Console API documentation: https://ddnexus.github.io/pagy/docs/api/console
# frozen_string_literal: true

require 'pagy'  # so you can require just the extra in the console
require 'pagy/extras/standalone'

class Pagy
  # Provide a ready to use pagy environment when included in irb/rails console
  module Console
    # Include Backend, Frontend and set the default URL
    def self.included(main)
      main.include(Backend)
      main.include(Frontend)
      DEFAULT[:url] = 'http://www.example.com/subdir'
    end

    # Require the extras passed as arguments
    def pagy_extras(*extras)
      extras.each { |extra| require "pagy/extras/#{extra}" }
      puts "Required extras: #{extras.map(&:inspect).join(', ')}"
    end
  end
end
