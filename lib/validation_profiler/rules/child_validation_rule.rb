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
        return false if field_value.nil?

        validation_profile = get_validation_profile(attributes, field)
        parent_field = build_parent_field(parent, field)

        validate_field_value(field_value, validation_profile, parent_field)
      end

      def validate_field_value(field_value, profile, parent_field)
        if field_value.is_a? Array
          field_value.map { |value| ValidationProfiler::Manager.new.validate(value, profile, parent_field) }
        else
          ValidationProfiler::Manager.new.validate(field_value, profile, parent_field)
        end
      end

      def build_parent_field(parent, field)
        return field.to_s if parent.nil?

        "#{parent}.#{field}"
      end

      def get_validation_profile(attributes, field)
        if attributes[:profile].nil?
          raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes
            .new(ValidationProfiler::Rules::ChildValidationRule, field)
        end

        attributes[:profile]
      end
    end
  end
end
