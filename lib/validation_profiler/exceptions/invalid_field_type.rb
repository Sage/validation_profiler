module ValidationProfiler
  module Exceptions
    class InvalidFieldType < StandardError

      def initialize(rule, field)
        @rule = rule
        @field = field
      end

      def to_s
        rule = @rule
        field = @field
        "Field: #{field} has an incorrect value type for Validation Rule: #{rule}."
      end

    end
  end
end