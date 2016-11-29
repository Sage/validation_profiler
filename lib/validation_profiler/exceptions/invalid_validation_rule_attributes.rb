module ValidationProfiler
  module Exceptions
    class InvalidValidationRuleAttributes < StandardError

      def initialize(rule, field)
        @rule = rule
        @field = field
      end

      def to_s
        rule = @rule
        field = @field
        "Incorrect attributes specified for Validation rule: #{rule} Field: #{field}."
      end

    end
  end
end