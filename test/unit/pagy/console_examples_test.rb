# frozen_string_literal: true

require_relative '../test_helper'
require 'open3'
require 'rbconfig'

describe 'Docs console examples' do
  it 'match the actual console output' do
    skip 'The docs show the Hash#inspect format of ruby >= 3.4' if RUBY_VERSION < '3.4'

    script = Pagy::ROOT.parent.join('scripts/update_console_examples.rb').to_s
    # The docs show the CURRENT API output, also when the suite runs with PAGY_NEXT
    output, status = Open3.capture2e({ 'PAGY_NEXT' => nil }, RbConfig.ruby, script, '--check')

    _(status.success?).must_equal true, "#{output}Run `bundle exec ruby scripts/update_console_examples.rb` to update them"
  end
end
