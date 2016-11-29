RSpec.describe ValidationProfiler::Rules::MatchValidationRule do

  describe '#validate' do

    it 'should correctly validate a matching pair of fields' do
      test_obj = TestObject.new
      test_obj.email = 'abc@example.com'
      test_obj.confirm = 'abc@example.com'
      expect(subject.validate(test_obj, :confirm, { field: :email })).to eq(true)
    end

    it 'should fail to validate a non matching pair of fields' do
      test_obj = TestObject.new
      test_obj.email = 'abc@example.com'
      test_obj.confirm = 'abc'
      expect(subject.validate(test_obj, :confirm, { field: :email })).to eq(false)
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:confirm, { field: :email })).to eq('confirm does not match email')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:confirm, { field: :email,  message: 'Please make sure the confirm value matches the email value' })).to eq('Please make sure the confirm value matches the email value')
    end

  end

end