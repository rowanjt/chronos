require 'runt' # ruby temporal expressions

module Chronos
  # EventScheduler
  class EventScheduler
    def initialize(white_blacklist = true)
      @schedule = Runt::Schedule.new
      @expr_builder = ExpressionBuilder.new

      @white_blacklist = white_blacklist
    end

    def add_constraints(constraints)
      return if constraints.key? :error

      constraints.each do |event_name, expressions|
        expressions = ([] << expressions).flatten
        expressions.each do |constraint|
          operation = constraint.fetch(:operation)
          expression = (constraint.values - [operation]).join('_')
          add_constraint(expression, operation)
        end

        schedule_event(event_name)
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

    def schedule_event(event_name)
      @schedule.add(event_name, constraints)
      reset_constraints
    end

    def check(time)
      if @white_blacklist
        # @schedule.include?(@event, time)
        @schedule.events(time).any?
      else
        @schedule.events(time).none?
      end
    end

    private

    def constraints
      # composite temporal expression
      @expr_builder.ctx
    end
  end
end
