require 'bigdecimal'
module ValidationProfiler
  module Rules
    class DecimalValidationRule < ValidationProfiler::Rules::ValidationRule

      def error_message(field, attributes = {}, parent = nil)

        field_name = field.to_s
        if parent != nil
          field_name = "#{parent.to_s}.#{field.to_s}"
        end

        #check if a custom error message has been specified in the attributes
        if attributes[:message] == nil
          #no custom error message has been specified so create the default message.
          "#{field_name} is not a valid Decimal"
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

        if !is_valid_decimal?(field_value)
          return false
        end

        return true

      end

      def is_valid_decimal?(value)
        if value.instance_of? BigDecimal
          true
        else
          (value.to_s =~ /\A[-+]?\d*\.?\d+\z/) == 0
        end
      end
    end
  end
end
