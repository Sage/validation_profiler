module ValidationProfiler
  module Rules
    # ListValidationRule class
    class ListValidationRule < ValidationProfiler::Rules::ValidationRule
      def error_message(field, attributes = {}, parent = nil)
        field_name = field.to_s
        field_name = "#{parent}.#{field}" unless parent.nil?

        if attributes[:message].nil?
          "#{field_name} is not an accepted value."
        else
          attributes[:message]
        end
      end

      def validate(obj, field, attributes = {}, parent = nil)
        field_value = get_field_value(obj, field)

        return true unless is_required?(field_value, attributes)
        return false if field_value.nil?

        list = attributes[:list]
        regex = attributes[:regex]

        raise_invalid_exception!(field) if regex.nil? && list.nil?

        if list
          raise_invalid_exception!(field) unless list.is_a?(Array)
          return false unless list.include?(field_value)
        elsif regex
          field_value.each do |value|
            return false unless value =~ regex
          end
        end

        true
      end

      private

      def raise_invalid_exception!(field)
        raise ValidationProfiler::Exceptions::InvalidValidationRuleAttributes
          .new(ValidationProfiler::Rules::ListValidationRule, field)
      end
    end
  end
end
