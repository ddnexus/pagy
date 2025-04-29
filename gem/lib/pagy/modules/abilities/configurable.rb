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
      targets.each { |filename| FileUtils.cp(ROOT.join('javascript', filename), destination) }
      (names - targets).each { |filename| FileUtils.rm_f(File.join(destination, filename)) }
    end

    # Generate the script and style tags to help development
    def dev_tags(wand_scale: 1)
      <<~HTML
        <script id="pagy-ai-widget">
          document.addEventListener('wand-positioned', #{ROOT.join('javascript/ai_widget.js').read});
        </script>
        <script id="pagy-wand" data-scale="#{wand_scale}">
          #{ROOT.join('javascript/wand.js').read}
        </script>
        <style id="pagy-wand-default">
          #{ROOT.join('stylesheet/pagy.css').read}
        </style>
      HTML
    end
  end
end
