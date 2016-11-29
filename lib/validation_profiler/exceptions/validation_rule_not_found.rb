module ValidationProfiler
  module Exceptions
    class ValidationRuleNotFound < StandardError

      def initialize(rule)
        @rule = rule
      end

      def to_s
        rule = @rule
        "Validation rule: #{rule} could not be found."
      end

    end
  end
end