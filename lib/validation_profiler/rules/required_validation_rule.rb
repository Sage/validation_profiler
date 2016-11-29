module ValidationProfiler
  module Rules
    class RequiredValidationRule < ValidationProfiler::Rules::ValidationRule

      def error_message(field, attributes = {}, parent = nil)

        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          "#{field_name} is required"
        else
          attributes[:message]
        end
      end


      def validate(obj, field, attributes = {}, parent = nil)

        #attempt to get the field value from the object
        field_value = get_field_value(obj, field)

        if field_value == nil
          return false
        end

        if field_value.is_a?(Array) || field_value.is_a?(String)
          return !field_value.empty?
        end

        return true

      end

    end
  end
end