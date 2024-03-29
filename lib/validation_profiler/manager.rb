module ValidationProfiler
  class Manager
    # Called to validate an object against a validation profile.
    #
    # @param obj [Object] The object to validate
    # @param profile [ClassName] The class name of the validation profile to validate against
    #
    # @return [ValidationManagerResult] The result of the validation
    def validate(obj, profile, parent = nil)
      result = ValidationProfiler::ManagerResult.new

      validation_rules = profile.class_variable_get(:@@validation_rules)

      validation_rules.each do |r|

        if ValidationProfiler::Rules::Manager.instance.nil?
          ValidationProfiler::Rules::Manager.new
        end

        rule = ValidationProfiler::Rules::Manager.instance.get_rule(r[:name])
        outcome = rule.validate(obj, r[:field], r[:attributes], parent)

        if outcome.is_a?(Array)
          result.errors += outcome.map(&:errors).flatten
        elsif outcome.is_a?(ValidationProfiler::ManagerResult) && !outcome.outcome
          result.errors += outcome.errors
        elsif !outcome
          result.errors.push(field: r[:field], message: rule.error_message(r[:field], r[:attributes], parent))
        end
      end

      result.outcome = result.errors.empty?

      result
    end

    # Called to add a custom validation rule to the manager
    #
    # @param key [Symbol] The name of the rule
    # @param rule [ClassName] Class name of the validation rule to register.
    def add_rule(key, rule)
      if ValidationProfiler::Rules::Manager.instance.nil?
        ValidationProfiler::Rules::Manager.new
      end

      ValidationProfiler::Rules::Manager.instance.add_rule(key, rule)
    end
  end
end
