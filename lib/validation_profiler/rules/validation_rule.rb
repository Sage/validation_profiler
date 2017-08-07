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
          raise ValidationProfiler::Exceptions::FieldNotFound.new(field) if !obj.respond_to?(field)

          #get the field value
          field_value = obj.send(field)
        end
      end

      def is_required?(field_value, attributes = {})
        required = attributes[:required]
        required = true if required.nil?

        #check if the field is required
        return false if required_field?(field_value, required)
        true
      end

      private

      def required_field?(field_value, required)
	(field_value.nil? || 
	  (field_value.respond_to?(:empty?) && field_value.empty?)) && 
	  !required
      end
    end
  end
end
