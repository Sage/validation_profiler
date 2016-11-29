module ValidationProfiler
  module Rules
    class TimeValidationRule < ValidationProfiler::Rules::ValidationRule

      def error_message(field, attributes = {}, parent = nil)

        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          "#{field_name} is not a valid time"
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

        begin
          if field_value.is_a?(Integer)
            Time.at(field_value)
          else
            begin
              Time.parse(field_value)
            rescue
              Time.at(Integer(field_value))
            end
          end
        rescue
          return false
        end

        return true

      end

    end
  end
end