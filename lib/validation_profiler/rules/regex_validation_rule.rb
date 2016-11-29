module ValidationProfiler
  module Rules
    class RegexValidationRule < ValidationProfiler::Rules::ValidationRule

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
        field_value = get_field_value(obj, field)

        regex = attributes[:regex]
        if regex == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::RegexValidationRule, field)
        end

        if !is_required?(field_value, attributes)
          return true
        end

        #validate the value against the regex
        if field_value =~ regex
          return true
        end

        return false

      end

    end
  end
end