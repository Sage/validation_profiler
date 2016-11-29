module ValidationProfiler
  module Rules
    class GuidValidationRule < ValidationProfiler::Rules::ValidationRule

      def error_message(field, attributes = {}, parent = nil)

        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          "#{field_name} is not a valid Guid"
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

        if field_value == nil || field_value.to_s.gsub(' ','').length == 0
          return false
        end

        field_value = field_value.to_s

        if attributes[:hyphens] == true && attributes[:brackets] == true
          if (field_value =~ /^[{(]?[0-9A-F]{8}[-]?([0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$/i) != 0
            return false
          end
        elsif attributes[:hyphens] == true
          if (field_value =~ /^?[0-9A-F]{8}[-]?([0-9A-F]{4}[-]?){3}[0-9A-F]{12}?$/i) != 0
            return false
          end
        elsif attributes[:brackets] == true
          if (field_value =~ /^[{(]?[0-9A-F]{8}?([0-9A-F]{4}?){3}[0-9A-F]{12}[)}]?$/i) != 0
            return false
          end
        else
          if (field_value =~ /^?[0-9A-F]{8}?([0-9A-F]{4}?){3}[0-9A-F]{12}?$/i) != 0
            return false
          end
        end

        return true

      end

    end
  end
end