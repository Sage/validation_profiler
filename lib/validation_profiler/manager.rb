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
          result.errors = outcome.map(&:errors).flatten
          result.outcome = result.errors.empty?
        elsif outcome.is_a?(ValidationProfiler::ManagerResult) && !outcome.outcome
          result.errors = result.errors + outcome.errors
          result.outcome = false
        elsif !outcome
          result.outcome = false
          result.errors.push(field: r[:field], message: rule.error_message(r[:field], r[:attributes], parent))
        end
      end

      result
    end
  end
end
