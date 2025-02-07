# frozen_string_literal: true

class Pagy
  module Javascript
    module_function

    # Provide the setup function to ensure that the pagy javascript
    # source files are installed and in sync with the Pagy::VERSION
    def sync_source(destination, *files)
      files = %(pagy.mjs pagy.js pagy.js.map pagy.min.js) if files.empty?
      files.each { |f| FileUtils.cp(ROOT.join('javascripts', f), destination) }
    end
  end
end
