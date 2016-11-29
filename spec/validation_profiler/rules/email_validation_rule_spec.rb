RSpec.describe ValidationProfiler::Rules::EmailValidationRule do

  describe '#validate' do

    it 'should correctly validate a valid email' do
      test_obj = TestObject.new
      test_obj.email = 'abc@example.com'
      expect(subject.validate(test_obj, :email)).to eq(true)
    end

    it 'should fail to validate an invalid email' do
      test_obj = TestObject.new
      test_obj.email = '123@123'
      expect(subject.validate(test_obj, :email)).to eq(false)
    end

    it 'should not fail validation for an empty email when not required' do
      test_obj = TestObject.new
      test_obj.email = nil
      expect(subject.validate(test_obj, :email, { required: false })).to eq(true)
    end

    it 'should fail to validate an empty email when required' do
      test_obj = TestObject.new
      test_obj.email = nil
      expect(subject.validate(test_obj, :email)).to eq(false)
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:email)).to eq('email is not a valid email address')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:email, { message: 'Please enter a valid email address' })).to eq('Please enter a valid email address')
    end

  end

end