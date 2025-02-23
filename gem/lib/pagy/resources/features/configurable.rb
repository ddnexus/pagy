# frozen_string_literal: true

class Pagy
  # Add configurstion methods
  module Configurable
    def translate_with_the_slower_i18n_gem!
      send(:remove_const, :I18n)
      send(:const_set, :I18n, ::I18n)
      ::I18n.load_path += Dir[ROOT.join('locales/*.yml')]
    end

    # Sync the pagy javascript targets
    def sync_javascript(destination, *targets)
      names   = %w[pagy.mjs pagy.js pagy.js.map pagy.min.js]
      targets = names if targets.empty?
      targets.each { |filename| FileUtils.cp(ROOT.join('javascripts', filename), destination) }
      (names - targets).each { |filename| FileUtils.rm_f(File.join(destination, filename)) }
    end
  end
end
