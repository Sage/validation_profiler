module ValidationProfiler
  module Rules
    class LengthValidationRule < ValidationProfiler::Rules::ValidationRule

      def error_message(field, attributes, parent = nil)
        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          min = attributes[:min]
          max = attributes[:max]
          if min && max
            "#{field_name} must have a min length of #{min} and a max length of #{max}"
          elsif min
            "#{field_name} must have a min length of #{min}"
          else
            "#{field_name} must have a max length of #{max}"
          end
        else
          attributes[:message]
        end
      end

      def validate(obj, field, attributes, parent = nil)

        min = attributes[:min]
        max = attributes[:max]

        #verify the expected attributes have been specified.
        if min == nil && max == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::LengthValidationRule, field)
        end

        #attempt to get the field value from the object
        field_value = get_field_value(obj, field)

        #check if this validation check should be skipped
        if !is_required?(field_value, attributes)
          return true
        end

        if field_value.is_a?(Array)
          length = field_value.length
        else
          length = field_value.to_s.length
        end

        #validate the field value
        if min && max
          return length >= min && length <= max
        elsif min
          return length >= min
        elsif max
          return length <= max
        end

        return false
      end

    end
  end
end