# frozen_string_literal: true

require_relative '../pagy'  # so you can require just the extra in the console

class Pagy
  # Provide the installer function for the pagy javascript files
  module Javascript
    module_function

    def install(*files, destination)
      files = %(pagy.mjs pagy.js pagy.js.map pagy.min.js) if files.empty?
      files.each { |f| FileUtils.cp(ROOT.join('javascripts', f), destination) }
    end
  end
end
