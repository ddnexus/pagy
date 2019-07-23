# Support module to capture search calls
# encoding: utf-8
# frozen_string_literal: true

class Pagy
  module Search
    # returns an array used to delay the call of #search
    # after the pagination variables are merged to the options
    # it also pushes to the same array an eventually called method and arguments
    # the last search argument must be a hash option
    def pagy_search(*search_args, &block)
      search_args << {} unless search_args[-1].is_a?(Hash)
      [self, search_args, block].tap do |args|
        args.define_singleton_method(:method_missing){|*a| args += a}
      end
    end
  end
end
