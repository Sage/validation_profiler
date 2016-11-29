module ValidationProfiler
  module Exceptions
    class FieldNotFound < StandardError

      def initialize(field)
        @field = field
      end

      def to_s
        field = @field
        "Field: #{field} could not be found."
      end

    end
  end
end