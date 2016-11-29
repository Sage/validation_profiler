module ValidationProfiler
  module Rules
    class EmailValidationRule < ValidationProfiler::Rules::ValidationRule

      REGEX = /^[^@]+@[^@]+\.[^@]+$/

      def error_message(field, attributes = {}, parent = nil)

        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          "#{field_name} is not a valid email address"
        else
          attributes[:message]
        end
      end


      def validate(obj, field, attributes = {}, parent = nil)

        #attempt to get the field value from the object
        field_value = get_field_value(obj, field)

        if !is_required?(field_value, attributes)
          return true
        end

        #validate the value against the regex
        if field_value =~ REGEX
          return true
        end

        return false

      end

    end
  end
end