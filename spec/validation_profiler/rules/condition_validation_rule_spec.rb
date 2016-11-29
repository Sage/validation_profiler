RSpec.describe ValidationProfiler::Rules::ConditionValidationRule do

  describe '#validate' do

    it "should correctly validate a condition that states when :text is 'ABC' then :email should be 'abc@example.com' when the condition is true" do
      test_obj = TestObject.new
      test_obj.text = 'ABC'
      test_obj.email = 'abc@example.com'
      expect(subject.validate(test_obj, :email, { condition_field: :text, condition_expression: '==', condition_value: 'ABC', field_expression: '==', field_value: 'abc@example.com' })).to eq(true)
    end

    it "should fail to validate a condition that states when :text is 'ABC' then :email should be 'abc@example.com' when the condition is not true" do
      test_obj = TestObject.new
      test_obj.text = 'ABC'
      test_obj.email = 'abc@example'
      expect(subject.validate(test_obj, :email, { condition_field: :text, condition_expression: '==', condition_value: 'ABC', field_expression: '==', field_value: 'abc@example.com' })).to eq(false)
    end

    it "should correctly validate a condition that states when :numeric is greater than 5 then :text should be 'More than 5 apples' when the condition is true" do
      test_obj = TestObject.new
      test_obj.numeric = 10
      test_obj.text = 'More than 5 apples'
      expect(subject.validate(test_obj, :text, { condition_field: :numeric, condition_expression: '>', condition_value: 5, field_expression: '==', field_value: 'More than 5 apples' })).to eq(true)
    end

    it "should fail to validate a condition that states when :numeric is greater than 5 then :text should be 'More than 5 apples' when the condition is false" do
      test_obj = TestObject.new
      test_obj.numeric = 10
      test_obj.text = nil
      expect(subject.validate(test_obj, :text, { condition_field: :numeric, condition_expression: '>', condition_value: 5, field_expression: '==', field_value: 'More than 5 apples' })).to eq(false)
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:text)).to eq('text is not valid')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:text, { message: 'Please make sure that text is specified when numeric is greater than 10' })).to eq('Please make sure that text is specified when numeric is greater than 10')
    end

  end

end