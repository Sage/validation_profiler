module ValidationProfiler
  module Rules
    class MaxValidationRule < ValidationProfiler::Rules::ValidationRule

      def error_message(field, attributes, parent = nil)

        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          max = attributes[:value]
          "#{field_name} must not have a value greater than #{max}"
        else
          attributes[:message]
        end
      end

      def validate(obj, field, attributes, parent = nil)

        max = attributes[:value]

        #verify the expected attributes have been specified.
        if max == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::MaxValidationRule, field)
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
          field_value <= max
        else
          raise ValidationProfiler::Exceptions::InvalidFieldType.new(ValidationProfiler::Rules::MaxValidationRule, field)
        end

      end

    end
  end
end