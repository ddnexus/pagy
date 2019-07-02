# encoding: utf-8
# frozen_string_literal: true

require 'digest'

class Pagy

  # default :steps: false will use {0 => @vars[:size]}
  VARS[:steps] = false

  # `Pagy` instance method used by the `pagy*_nav_js` helpers.
  # It returns the sequels of width/series generated from the :steps hash
  # Example:
  # >> pagy = Pagy.new(count:1000, page: 20, steps: {0 => [1,2,2,1], 350 => [2,3,3,2], 550 => [3,4,4,3]})
  # >> pagy.sequels
  # #=> { "0"   => [1, :gap, 18, 19, "20", 21, 22, :gap, 50],
  #       "350" => [1, 2, :gap, 17, 18, 19, "20", 21, 22, 23, :gap, 49, 50],
  #       "550" => [1, 2, 3, :gap, 16, 17, 18, 19, "20", 21, 22, 23, 24, :gap, 48, 49, 50] }
  # Notice: if :steps is false it will use the single {0 => @vars[:size]} size
  def sequels
    steps = @vars[:steps] || {0 => @vars[:size]}
    steps.key?(0) or raise(VariableError.new(self), "expected :steps to define the 0 width; got #{steps.inspect}")
    sequels = {}; steps.each {|width, size| sequels[width.to_s] = series(size)}; sequels
  end

  module Frontend

    if defined?(Oj)
      # it returns a script tag with the JSON-serialized args generated with the faster oj gem
      def pagy_json_tag(*args)
        %(<script type="application/json" class="pagy-json">#{Oj.dump(args, mode: :strict)}</script>)
      end
    else
      require 'json'
      # it returns a script tag with the JSON-serialized args generated with the slower to_json
      def pagy_json_tag(*args)
        %(<script type="application/json" class="pagy-json">#{args.to_json}</script>)
      end
    end

    # it returns the SHA1 (fastest on modern ruby) string used as default `id` attribute by all the `*_js` tags
    def pagy_id
      "pagy-#{Digest::SHA1.hexdigest(caller(2..2)[0].split(':in')[0])}"
    end

    # it returns the marked link to used by pagy.js
    def pagy_marked_link(link)
      link.call(MARK, '', 'style="display: none;"')
    end

  end

end
