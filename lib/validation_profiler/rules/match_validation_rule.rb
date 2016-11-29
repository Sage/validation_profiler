module ValidationProfiler
  module Rules
    class MatchValidationRule < ValidationProfiler::Rules::ValidationRule

      def error_message(field, attributes, parent = nil)

        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        match_field = attributes[:field]

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          "#{field_name} does not match #{match_field}"
        else
          attributes[:message]
        end
      end


      def validate(obj, field, attributes, parent = nil)

        #attempt to get the field value from the object
        field_value = get_field_value(obj, field)

        match_field = attributes[:field]
        if match_field == nil
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes.new(ValidationProfiler::Rules::MatchValidationRule, field)
        end

        if !is_required?(field_value, attributes)
          return true
        end

        match_field_value = get_field_value(obj, match_field)

        return field_value == match_field_value

      end

    end
  end
end