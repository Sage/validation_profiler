module ValidationProfiler
  module Rules
    class ValidationRule

      def get_field_value(obj, field)
        #attempt to get the field value from the object
        field_value = nil
        #check if the object is a hash
        if obj.is_a?(Hash)
          if obj.has_key?(field)
            #get the field value
            field_value = obj[field]
          elsif obj.has_key?(field.to_s)
            field_value = obj[field.to_s]
          end
        else
          #if the object does not contain the specified field raise an exception
          if !obj.respond_to?(field)
            raise ValidationProfiler::Exceptions::FieldNotFound.new(field)
          end

          #get the field value
          field_value = obj.send(field)
        end
      end

      def is_required?(field_value, attributes = {})
        required = attributes[:required]
        if required == nil
          required = true
        end

        #check if the field is required
        if field_value == nil && required == false
          return false
        else
          return true
        end
      end

    end
  end
end