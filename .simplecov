if ENV['RUN_SIMPLECOV']
  SimpleCov.command_name 'main'
  SimpleCov.start do
    add_filter %r{^/test/}
    add_group 'Core', %w[lib/pagy.rb lib/pagy/backend.rb lib/pagy/frontend.rb ]
    add_group 'Extras', %w[lib/pagy/countless.rb lib/pagy/extras]
  end
end
