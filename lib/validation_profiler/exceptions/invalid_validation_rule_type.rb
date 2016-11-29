module ValidationProfiler
  module Exceptions
    class InvalidValidationRuleType < StandardError

      def initialize(rule)
        @rule = rule
      end

      def to_s
        rule = @rule
        "Validation rule: #{rule} is not a valid type. Rules must inherit from the ValidationRule base class."
      end

    end
  end
end