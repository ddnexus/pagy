# frozen_string_literal: true

require 'pagy'  # so you can require just the extra in the console
require 'pagy/extras/standalone'

class Pagy
  # include Pagy::Console in irb/rails console for a ready to use pagy environment
  module Console
    def self.included(main)
      main.include(Backend)
      main.include(Frontend)
      VARS[:url] = 'http://www.example.com/subdir'
    end

    def pagy_extras(*extras)
      extras.each { |extra| require "pagy/extras/#{extra}" }
      puts "Required extras: #{extras.map(&:inspect).join(', ')}"
    end
  end
end
