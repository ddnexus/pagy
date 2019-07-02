# encoding: utf-8
# frozen_string_literal: true

require 'pagy'

class Pagy

  class Countless < Pagy

    # Merge and validate the options, do some simple arithmetic and set a few instance variables
    def initialize(vars={})
      @vars = VARS.merge(vars.delete_if{|_,v| v.nil? || v == '' })      # default vars + cleaned vars (can be overridden)
      { items:1, outset:0, page:1 }.each do |k,min|                     # validate instance variables
        (@vars[k] && instance_variable_set(:"@#{k}", @vars[k].to_i) >= min) \
         or raise(VariableError.new(self), "expected :#{k} >= #{min}; got #{@vars[k].inspect}")
      end
      @offset = @items * (@page - 1) + @outset                          # pagination offset + outset (initial offset)
    end

    # Finalize the instance variables based on the fetched items
    def finalize(fetched)
      fetched == 0 && @page > 1 and raise(OverflowError.new(self), "page #{@page} got no items")
      @pages = @last = (fetched > @items ? @page + 1 : @page)         # set the @pages and @last
      @items = fetched if fetched < @items && fetched > 0             # adjust items for last non-empty page
      @from  = fetched == 0 ? 0 : @offset+1 - @outset                 # page begins from item
      @to    = fetched == 0 ? 0 : @offset + @items - @outset          # page ends to item
      @prev  = (@page-1 unless @page == 1)                            # nil if no prev page
      @next  = @page == @last ? (1 if @vars[:cycle]) : @page+1        # nil if no next page, 1 if :cycle
      self
    end

  end
end
