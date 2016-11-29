module ValidationProfiler
  module Rules
    class MinValidationRule < ValidationProfiler::Rules::ValidationRule

      def error_message(field, attributes, parent = nil)

        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          min = attributes[:value]
          "#{field_name} must have a minimum value of #{min}"
        else
          attributes[:message]
        end
      end

      def validate(obj, field, attributes, parent = nil)

        min = attributes[:value]

        #verify the expected attributes have been specified.
        if min == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::MinValidationRule, field)
        end

        #attempt to get the field value from the object
        field_value = get_field_value(obj, field)

        if !is_required?(field_value, attributes)
          return true
        end

        if field_value == nil
          return false
        end

        if field_value.is_a?(DateTime) || field_value.is_a?(Numeric)
          field_value >= min
        else
          raise ValidationProfiler::Exceptions::InvalidFieldType.new(ValidationProfiler::Rules::MinValidationRule, field)
        end

      end

    end
  end
end