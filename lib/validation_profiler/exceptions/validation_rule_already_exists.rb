module ValidationProfiler
  module Exceptions
    class ValidationRuleAlreadyExists < StandardError

      def initialize(key)
        @key = key
      end

      def to_s
        key = @key
        "A Rule has already been registered for the key: #{key}."
      end

    end
  end
end