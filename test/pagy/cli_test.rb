# frozen_string_literal: true

require_relative '../test_helper'
require 'pagy/cli'

describe Pagy::CLI do
  let(:cli) { Pagy::CLI.new }

  # Stub side-effects: setup_gems
  before do
    cli.define_singleton_method(:setup_gems) { |_| true }
  end

  describe 'Options' do
    it 'shows help with no args' do
      # Capture stdout and expect exit(0)
      out, = capture_io do
        _ { cli.start([]) }.must_raise SystemExit
      end
      _(out).must_include 'Usage:'
    end

    it 'shows version' do
      out, = capture_io do
        _ { cli.start(['-v']) }.must_raise SystemExit
      end
      _(out).must_include Pagy::VERSION
    end

    it 'aborts on invalid option' do
      # Capture stderr and expect abort (SystemExit)
      _, err = capture_io do
        _ { cli.start(['--invalid']) }.must_raise SystemExit
      end
      _(err).must_include 'invalid option: --invalid'
    end
  end

  describe 'Clone' do
    it 'aborts if app not found' do
      _, err = capture_io do
        _ { cli.start(%w[clone foo]) }.must_raise SystemExit
      end
      _(err).must_include 'Expected APP to be in'
    end

    it 'clones app' do
      FileUtils.stub :cp, true, [PagyApps::INDEX['demo'], '.', { verbose: true }] do
        cli.start(%w[clone demo])
      end
    end

    it 'aborts if file exists and user says no' do
      File.stub :exist?, true do
        # Stub 'gets' (used for user input)
        cli.stub :gets, 'n' do
          _, err = capture_io do
            _ { cli.start(%w[clone demo]) }.must_raise SystemExit
          end
          _(err).must_include 'already present'
        end
      end
    end

    it 'overwrites if user says yes' do
      File.stub :exist?, true do
        cli.stub :gets, 'y' do
          FileUtils.stub :cp, true do
            capture_io { cli.start(%w[clone demo]) }
          end
        end
      end
    end
  end

  describe 'Serve' do
    it 'launches showcase app' do
      # Stub 'exec' to capture the command instead of running it
      cli.stub :exec, ->(cmd) { cmd } do
        cmd = cli.start(['demo', '-p', '9000'])
        _(cmd).must_include 'rackup'
        _(cmd).must_include 'demo.ru'
        _(cmd).must_include '-p 9000'
        _(cmd).must_include '-E showcase'
        _(cmd).must_include '-q'
      end
    end

    it 'launches local file' do
      File.stub :exist?, true do
        cli.stub :exec, ->(cmd) { cmd } do
          cmd = cli.start(['my.ru', '-e', 'production'])
          _(cmd).must_include 'my.ru'
          _(cmd).must_include '-E production'
        end
      end
    end

    it 'aborts if local file missing' do
      _, err = capture_io do
        _ { cli.start(['missing.ru']) }.must_raise SystemExit
      end
      _(err).must_include 'app not found'
    end
  end
end
