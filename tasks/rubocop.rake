# encoding: utf-8
# frozen_string_literal: true

if ENV['RUBOCOP'] == 'true' || !ENV['CI']
  require "rubocop/rake_task"
  RuboCop::RakeTask.new(:rubocop)
end