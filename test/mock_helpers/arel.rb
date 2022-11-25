# frozen_string_literal: true

module Arel
  def self.star(*)
    self
  end

  def self.count(*)
    self
  end

  def self.over(*)
    self
  end

  module Nodes
    class Grouping
      # rubocop:disable Lint/RedundantCopDisableDirective
      # rubocop:disable Style/RedundantInitialize
      def initialize(_); end
      # rubocop:enable Style/RedundantInitialize
      # rubocop:enable Lint/RedundantCopDisableDirective
    end
  end
end
