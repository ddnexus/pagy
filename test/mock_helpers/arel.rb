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
      def initialize(array)
      end
    end
  end
end
