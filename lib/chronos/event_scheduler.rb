require 'runt' # ruby temporal expressions

module Chronos
  class EventScheduler
    def initialize(event_name, white_blacklist=true)
      @schedule = Runt::Schedule.new
      @event = Runt::Event.new(event_name)
      @expr_builder = ExpressionBuilder.new

      @white_blacklist = white_blacklist
    end

    def add_constraints(constraints)
      constraints.each do |constraint|
        operation = constraint.fetch(:operation)
        expression = (constraint.values - [operation]).join('_')
        add_constraint(expression, operation)
      end
    end

    def add_constraint(expression, operation)
      # use send to call symbol and string methods
      @expr_builder.define { send(operation, send(expression)) }
    end

    def schedule_event
      # NOTE: add will overwrite previous event expression
      @schedule.add(@event, composite_temporal_expr)
      @expr_builder.reset
    end

    def check(time)
      if @white_blacklist
        @schedule.include?(@event, time)
      else
        !@schedule.include?(@event, time)
      end
    end

    private

    def composite_temporal_expr
      @expr_builder.ctx
    end
  end
end
