# frozen_string_literal: true

class Pagy
  # Add configurstion methods
  module Configurable
    # Sync the pagy javascript targets
    def sync_javascript(destination, *targets)
      names   = %w[pagy.mjs pagy.js pagy.js.map pagy.min.js]
      targets = names if targets.empty?
      targets.each { |filename| FileUtils.cp(ROOT.join('javascripts', filename), destination) }
      (names - targets).each { |filename| FileUtils.rm_f(File.join(destination, filename)) }
    end

    # Generate the script and style tags to help development
    def dev_tools(wand_scale: 1)
      <<~HTML
        <script id="pagy-ai-widget">
          #{ROOT.join('javascripts/ai_widget.js').read}
          document.addEventListener('wand-positioned', PagyAIWidget.appendWidgetScript );
          document.addEventListener('turbo:load', () => {
            window.chatWidget = new ChatWidget();
            PagyAIWidget.editChatWidget();
          };
        </script>
        <script id="pagy-wand" data-scale="#{wand_scale}">
          #{ROOT.join('javascripts/wand.js').read}
        </script>
        <style id="pagy-wand-default">
          #{ROOT.join('stylesheets/pagy.css').read}
        </style>
      HTML
    end

    # Setup pagy for using the i18n gem
    def translate_with_the_slower_i18n_gem!
      send(:remove_const, :I18n)
      send(:const_set, :I18n, ::I18n)
      ::I18n.load_path += Dir[ROOT.join('locales/*.yml')]
    end
  end
end
