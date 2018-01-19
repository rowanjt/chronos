require 'runt' # ruby temporal expressions

module Chronos
  # EventScheduler
  class EventScheduler
    def initialize(event_name, white_blacklist = true)
      @schedule = Runt::Schedule.new
      @event = Runt::Event.new(event_name)
      @expr_builder = ExpressionBuilder.new

      @white_blacklist = white_blacklist
    end

    def add_constraints(constraints)
      return if constraints.any? { |c| c.key? :error }

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

    def reset_constraints
      # NOTE: add will overwrite previous event expression
      @expr_builder.reset
    end

    def constraints?
      !constraints.is_a?(Runt::Expressions::NullExpression)
    end

    def schedule_event
      @schedule.add(@event, constraints)
      reset_constraints
    end

    def check(time)
      if @white_blacklist
        @schedule.include?(@event, time)
      else
        !@schedule.include?(@event, time)
      end
    end

    private

    def constraints
      # composite temporal expression
      @expr_builder.ctx
    end
  end
end
