RSpec.describe ValidationProfiler::Rules::RegexValidationRule do

  describe '#validate' do

    it 'should correctly validate a regex with a match' do
      test_obj = TestObject.new
      test_obj.text = 'abc@example.com'
      expect(subject.validate(test_obj, :text, { regex: /^[^@]+@[^@]+\.[^@]+$/ })).to eq(true)
    end

    it 'should fail to validate a regex without any matches' do
      test_obj = TestObject.new
      test_obj.text = '123@123'
      expect(subject.validate(test_obj, :text, { regex: /^[^@]+@[^@]+\.[^@]+$/ })).to eq(false)
    end

    it 'should not fail validation for an empty field when not required' do
      test_obj = TestObject.new
      test_obj.text = nil
      expect(subject.validate(test_obj, :text, { regex: /^[^@]+@[^@]+\.[^@]+$/, required: false })).to eq(true)
    end

    it 'should fail to validate an empty field when required' do
      test_obj = TestObject.new
      test_obj.text = nil
      expect(subject.validate(test_obj, :text, { regex: /^[^@]+@[^@]+\.[^@]+$/ })).to eq(false)
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:regex)).to eq('regex is not valid')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:regex, { message: 'Please enter a valid email address' })).to eq('Please enter a valid email address')
    end

  end

end