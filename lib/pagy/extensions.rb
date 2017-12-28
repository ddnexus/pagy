class Pagy

  # for rails apps
  if defined?(Rails)                                         # minimal rails engine class, only needed to make
    class Engine < ::Rails::Engine; end                      # the example templates directly available to a rails app
  end

  autoload :ActiveRecordPageScope, 'pagy/extensions/active_record_page_scope'
  autoload :ArrayPageMethod,       'pagy/extensions/array_page_method'

end
