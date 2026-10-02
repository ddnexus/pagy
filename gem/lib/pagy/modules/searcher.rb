# frozen_string_literal: true

class Pagy
  module Searcher
    module_function

    # Common search logic
    def wrap(search_arguments, options)
      resolve(options)
      pagy, results = yield
      *, calls = search_arguments

      [pagy, chain(results, calls)]
    end

    # Resolve the page and limit from the request
    def resolve(options)
      options[:page] ||= options[:request].resolve_page
      options[:limit]  = options[:request].resolve_limit
    end

    # Apply the calls recorded by Search::Arguments
    def chain(receiver, calls)
      calls.reduce(receiver) { |object, (name, args, kwargs, block)| object.send(name, *args, **kwargs, &block) }
    end
  end
end
