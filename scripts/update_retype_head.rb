#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'scripty'
include Scripty  # rubocop:disable Style/MixinUsage

# Prompt for the old version tag
require_relative '../gem/lib/pagy'

# Insert the latest ai-widget in the retype head
replace_section_in_file('docs/_includes/head.html', 'ai_widget', <<~HTML)
  <!-- GENERATED FILE! DO NOT EDIT -->
  <script>
    #{Pagy::ROOT.join('javascripts/ai_widget.js').read}
  </script>
HTML
