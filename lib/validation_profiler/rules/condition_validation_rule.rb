module ValidationProfiler
  module Rules
    class ConditionValidationRule < ValidationProfiler::Rules::ValidationRule

      def error_message(field, attributes = {}, parent = nil)

        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          "#{field_name} is not valid"
        else
          attributes[:message]
        end
      end


      def validate(obj, field, attributes, parent = nil)

        #attempt to get the field value from the object
        value = get_field_value(obj, field)

        condition_field = attributes[:condition_field]
        if condition_field == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::ConditionValidationRule, field)
        end

        condition_value = attributes[:condition_value]
        if condition_value == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::ConditionValidationRule, field)
        end

        condition_expression = attributes[:condition_expression]
        if condition_expression == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::ConditionValidationRule, field)
        end

        field_expression = attributes[:field_expression]
        if field_expression == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::ConditionValidationRule, field)
        end

        field_value = attributes[:field_value]
        if field_value == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::ConditionValidationRule, field)
        end

        if !is_required?(value, attributes)
          return true
        end

        condition_field_value = get_field_value(obj, condition_field)

        #check if the condition is valid
        if confirm_expression?(condition_field_value, condition_expression, condition_value)
          #check if the field value is correct for the condition
          if confirm_expression?(value, field_expression, field_value)
            return true
          else
            return false
          end
        end

        return true

      end

      def confirm_expression?(value_a, expression, value_b)
        a = value_a
        b = value_b

        if value_a.is_a?(String)
          a = "'#{value_a}'"
        elsif value_a == nil
          a = 'nil'
        end

        if value_b.is_a?(String)
          b = "'#{value_b}'"
        elsif value_b == nil
          b = 'nil'
        end

        eval("#{a}.#{expression} #{b}")
      end

    end
  end
end
