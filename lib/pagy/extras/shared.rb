# encoding: utf-8
# frozen_string_literal: true

require 'json'
require 'digest'

class Pagy

  # Default :breakpoints
  VARS[:breakpoints] = { 0 => [1,4,4,1] }

  # Helper for building the page_nav with javascript. For example:
  # with an object like:
  #   Pagy.new count:1000, page: 20, breakpoints: {0 => [1,2,2,1], 350 => [2,3,3,2], 550 => [3,4,4,3]}
  # it returns something like:
  #   { :items  => [1, :gap, 18, 19, "20", 21, 22, 50, 2, 17, 23, 49, 3, 16, 24, 48],
  #     :series => { 0   =>[1, :gap, 18, 19, "20", 21, 22, :gap, 50],
  #                  350 =>[1, 2, :gap, 17, 18, 19, "20", 21, 22, 23, :gap, 49, 50],
  #                  550 =>[1, 2, 3, :gap, 16, 17, 18, 19, "20", 21, 22, 23, 24, :gap, 48, 49, 50] },
  #     :widths => [550, 350, 0] }
  # where :items  is the unordered array union of all the page numbers for all sizes (passed to the PagyResponsive javascript function)
  #       :series is the hash of the series keyed by width (used by the *_responsive helpers to create the JSON string)
  #       :widths is the desc-ordered array of widths (passed to the PagyResponsive javascript function)
  def responsive
    @responsive ||= {items: [], series: {}, widths:[]}.tap do |r|
      @vars[:breakpoints].key?(0) || raise(ArgumentError, "expected :breakpoints to contain the 0 size; got #{@vars[:breakpoints].inspect}")
      @vars[:breakpoints].each {|width, size| r[:items] |= r[:series][width] = series(size)}
      r[:widths] = r[:series].keys.sort!{|a,b| b <=> a}
    end
  end

  module Frontend

    def pagy_json_tag(*args)
      %(<script type="application/json" class="pagy-json">#{args.to_json}</script>)
    end

    def pagy_id
      # SHA1 is the fastest on modern ruby
      "pagy-#{Digest::SHA1.hexdigest(caller(2..2)[0].split(':in')[0])}"
    end

  end

end
