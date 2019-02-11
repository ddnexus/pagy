# Support module to capture search calls
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  module Search
    # returns an array used to delay the call of #search
    # after the pagination variables are merged to the options
    # it also pushes to the same array an eventually called method and arguments
    def pagy_search(arg, options={}, &block)
      [self, arg, options, block].tap do |args|
        args.define_singleton_method(:method_missing){|*a| args += a}
      end
    end
  end
end
