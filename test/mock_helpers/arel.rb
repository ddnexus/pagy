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
      def initialize(_)
        puts ""     # rubocop bug!
      end
    end
  end
end
