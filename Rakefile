# frozen_string_literal: true

Rake.add_rakelib 'tasks'

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop)

task default: %i[rubocop test]
