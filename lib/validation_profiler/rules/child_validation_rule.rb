module ValidationProfiler
  module Rules
    # Validation rule for child attributes
    class ChildValidationRule < ValidationProfiler::Rules::ValidationRule
      def error_message(field, attributes = {}, parent = nil)
        field_name = field.to_s
        field_name = "#{parent}.#{field}" unless parent.nil?

        # check if a custom error message has been specified in the attributes
        if attributes[:message].nil?
          # no custom error message has been specified so create the default message.
          "#{field_name} is required."
        else
          attributes[:message]
        end
      end

      def validate(obj, field, attributes = {}, parent = nil)
        # attempt to get the field value from the object
        field_value = get_field_value(obj, field)

        return true unless is_required?(field_value, attributes)

        profile = attributes[:profile]
        if profile.nil?
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes
            .new(ValidationProfiler::Rules::ChildValidationRule, field)
        end

        return false if field_value.nil?

        parent_field = field.to_s
        parent_field = "#{parent}.#{field}" unless parent.nil?

        if field_value.is_a? Array
          result = field_value.map { |value| ValidationProfiler::Manager.new.validate(value, profile, parent_field) }
        else
          result = ValidationProfiler::Manager.new.validate(field_value, profile, parent_field)
        end

        result
      end
    end
  end
end
