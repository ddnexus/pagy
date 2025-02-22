# frozen_string_literal: true

class Pagy
  # Add configurstion methods
  module Configurable
    def translate_with_the_slower_i18n_gem!
      send(:remove_const, :I18n)
      send(:const_set, :I18n, ::I18n)
      ::I18n.load_path += Dir[ROOT.join('locales/*.yml')]
    end

    # Ensure that the pagy javascript target formats are installed and in sync with the Pagy::VERSION
    def sync_javascript(destination, *formats)
      files = { mjs: 'pagy.mjs', js: 'pagy.js', map: 'pagy.js.map', min: 'pagy.min.js' }
      (invalid = formats - files.keys).empty? || raise(Errno::ENOENT, "Invalid format(s): #{invalid.join(', ')}")

      targets = formats.empty? ? files.values : files.values_at(*formats)
      targets.each { |filename| FileUtils.cp(ROOT.join('javascripts', filename), destination) }
      (files.values - targets).each { |filename| FileUtils.rm_f(File.join(destination, filename)) }
    end
  end
end
