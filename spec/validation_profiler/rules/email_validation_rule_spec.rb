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

    context 'when the multiple: true attribute is provided' do

      it 'should fail validation if the value is not a string' do
        test_obj = TestObject.new
        test_obj.email = 123
        expect(subject.validate(test_obj, :email, { multiple: true })).to eq(false)
      end

      it 'should correctly validate a single valid email' do
        test_obj = TestObject.new
        test_obj.email = 'abc@example.com'
        expect(subject.validate(test_obj, :email, { multiple: true })).to eq(true)
      end

      it 'should fail to validate a single invalid email' do
        test_obj = TestObject.new
        test_obj.email = '123@123'
        expect(subject.validate(test_obj, :email, { multiple: true })).to eq(false)
      end

      it 'should correctly validate multiple valid emails comma separated' do
        test_obj = TestObject.new
        test_obj.email = 'abc@example.com, def@example.com, ghi@example.com'
        expect(subject.validate(test_obj, :email, { multiple: true })).to eq(true)
      end

      it 'should correctly validate multiple valid emails semicolon separated' do
        test_obj = TestObject.new
        test_obj.email = 'abc@example.com; def@example.com; ghi@example.com'
        expect(subject.validate(test_obj, :email, { multiple: true })).to eq(true)
      end

      it 'should fail to validate multiple emails when one is invalid' do
        test_obj = TestObject.new
        test_obj.email = 'abc@example.com, def@example.com, ghi@examplecom'
        expect(subject.validate(test_obj, :email, { multiple: true })).to eq(false)
      end

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