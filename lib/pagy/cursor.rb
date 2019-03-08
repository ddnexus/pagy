class Pagy

  class Cursor < Pagy
    attr_reader :before, :after, :arel_table, :primary_key, :order, :comparation, :position, :prev_comparation
    attr_accessor :has_more, :has_prev
    alias_method :has_more?, :has_more
    alias_method :has_prev?, :has_more

    def initialize(vars)
      @vars = VARS.merge(vars.delete_if{|_,v| v.nil? || v == '' })
      @items = vars[:items] || VARS[:items]
      @before = vars[:before]
      @after = vars[:after]
      @arel_table = vars[:arel_table]
      @primary_key = vars[:primary_key]
      if @before.present? and @after.present?
        raise(ArgumentError, 'before and after can not be both mentioned')
      end

      if vars[:backend] == 'uuid'

        if @after.present?
          @comparation = 'gt' # arel table greater than
          @position = @after
          @order = { :created_at => :asc , @primary_key => :asc }
        else
          @comparation = 'lt' # arel table less than
          @position = @before
          @order = { :created_at => :desc , @primary_key => :desc }
        end

      else

        if @after.present?
          @comparation = 'gt'
          @position = @after
          @order = { @primary_key => :asc }
        else      
          @comparation = 'lt'
          @position = @before
          @order = { @primary_key => :desc }
        end
      end
      
    end
  end
 end
