RSpec.describe ValidationProfiler::Rules::MaxValidationRule do

  describe '#validate' do

    it 'should correctly validate an integer of 5 as having a maximum value of 6' do
      test_obj = TestObject.new
      test_obj.numeric = 5
      expect(subject.validate(test_obj, :numeric, { value: 6 })).to eq(true)
    end

    it 'should fail to validate an integer of 7 as having a maximum value of 6' do
      test_obj = TestObject.new
      test_obj.numeric = 7
      expect(subject.validate(test_obj, :numeric, { value: 6 })).to eq(false)
    end

    it 'should correctly validate a datetime of today as having a maximum value of tomorrow' do
      test_obj = TestObject.new
      test_obj.datetime = DateTime.now
      expect(subject.validate(test_obj, :datetime, { value: DateTime.now + 1 })).to eq(true)
    end

    it 'should fail to validate a datetime of tomorrow as having a maximum value of today' do
      test_obj = TestObject.new
      test_obj.datetime = DateTime.now + 1
      expect(subject.validate(test_obj, :datetime, { value: DateTime.now })).to eq(false)
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:numeric, { value: 5 })).to eq('numeric must not have a value greater than 5')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:numeric, { value: 5, message: 'The numeric field must not have a value greater than 5' })).to eq('The numeric field must not have a value greater than 5')
    end

  end

end