# frozen_string_literal: true

require_relative '../pagy'  # so you can require just the extra in the console

class Pagy
  # Provide a ready to use pagy environment when included in irb/rails console
  module Config
    module_function

    def install_js(*files, destination)
      files = %(pagy.mjs pagy.js pagy.js.map pagy.min.js) if files.empty?
      files.each { |f| FileUtils.cp(ROOT.join('javascripts', f), destination) }
    end
  end
end
