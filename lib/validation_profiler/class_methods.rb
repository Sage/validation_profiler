class Class

  #[DEPRECIATED] do not use, please use 'extend ValidationProfiler' instead
  # Specifies a validation rule to use within a validation profile.
  #
  # @param field [Symbol] The name of the field to validate
  # @param rule [Symbol] The name of the validation rule to use
  # @param attributes [Hash] [Optional] A has containing the validation rule options
  def validates(field, rule, attributes = {})

    puts "[ValidationProfile] - Method depreciated. Please use 'extend ValidationProfiler' in your validation profile class to access the 'validates' method."

    if !self.class_variable_defined?(:@@validation_rules)
      self.class_variable_set(:@@validation_rules, [])
    end

    validation_rules = self.class_variable_get(:@@validation_rules)
    validation_rules.push({ name: rule, field: field, attributes: attributes })

    self.class_variable_set(:@@validation_rules, validation_rules)

  end

end

module ValidationProfiler
  # Specifies a validation rule to use within a validation profile.
  #
  # @param field [Symbol] The name of the field to validate
  # @param rule [Symbol] The name of the validation rule to use
  # @param attributes [Hash] [Optional] A has containing the validation rule options
  def validates(field, rule, attributes = {})

    if !self.class_variable_defined?(:@@validation_rules)
      self.class_variable_set(:@@validation_rules, [])
    end

    validation_rules = self.class_variable_get(:@@validation_rules)
    validation_rules.push({ name: rule, field: field, attributes: attributes })

    self.class_variable_set(:@@validation_rules, validation_rules)

  end
end