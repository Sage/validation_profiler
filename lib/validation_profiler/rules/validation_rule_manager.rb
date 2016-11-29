require_relative '../../../lib/validation_profiler/rules/child_validation_rule'

module ValidationProfiler
  module Rules
    # This is the manager class that holds all registered validation rules.
    class Manager

      class << self
        attr_accessor :instance
      end

      def initialize
        @rules = []
        ValidationProfiler::Rules::Manager.instance = self
        load_rules
      end

      # This method is called to get a validation rule by it's registered key.
      #
      # @params key [Symbol] This is the key of the validation rule you want to request.
      #
      # @return [ValidationRule] This is the requested ValidationRule instance.
      def get_rule(key)

        results = @rules.select { |r| r[:key] == key }
        if !results.empty?
          results[0][:instance]
        else
          raise ValidationProfiler::Exceptions::ValidationRuleNotFound.new(key)
        end
      end

      # This method is called to add a validation rule to the manager for use.
      #
      # @param key [Symbol] This is the key to register the validation rule for.
      # @param rule [ClassName] This is the class name of the validation rule to register.
      def add_rule(key, rule)

        instance = rule.new

        #verify the rule instance inherits ValidationRule
        if instance == nil || !instance.is_a?(ValidationRule)
          raise ValidationProfiler::Exceptions::InvalidValidationRuleType.new(instance.class)
        end

        #verify the rule name has not already been registered
        if !@rules.select { |r| r[:key] == key }.empty?
          raise ValidationProfiler::Exceptions::ValidationRuleAlreadyExists.new(key)
        end

        @rules.push({ key: key, instance: instance})

      end

      private

      def load_rules

        @rules.push({ key: :required, instance: ValidationProfiler::Rules::RequiredValidationRule.new })
        @rules.push({ key: :length, instance: ValidationProfiler::Rules::LengthValidationRule.new })
        @rules.push({ key: :min, instance: ValidationProfiler::Rules::MinValidationRule.new })
        @rules.push({ key: :max, instance: ValidationProfiler::Rules::MaxValidationRule.new })
        @rules.push({ key: :email, instance: ValidationProfiler::Rules::EmailValidationRule.new })
        @rules.push({ key: :regex, instance: ValidationProfiler::Rules::RegexValidationRule.new })
        @rules.push({ key: :match, instance: ValidationProfiler::Rules::MatchValidationRule.new })
        @rules.push({ key: :condition, instance: ValidationProfiler::Rules::ConditionValidationRule.new })
        @rules.push({ key: :not_allowed, instance: ValidationProfiler::Rules::NotAllowedValidationRule.new })
        @rules.push({ key: :list, instance: ValidationProfiler::Rules::ListValidationRule.new })
        @rules.push({ key: :child, instance: ValidationProfiler::Rules::ChildValidationRule.new })
        @rules.push({ key: :date, instance: ValidationProfiler::Rules::DateValidationRule.new })
        @rules.push({ key: :time, instance: ValidationProfiler::Rules::TimeValidationRule.new })
        @rules.push({ key: :int, instance: ValidationProfiler::Rules::IntegerValidationRule.new })
        @rules.push({ key: :decimal, instance: ValidationProfiler::Rules::DecimalValidationRule.new })
        @rules.push({ key: :guid, instance: ValidationProfiler::Rules::GuidValidationRule.new })

      end

    end
  end
end
