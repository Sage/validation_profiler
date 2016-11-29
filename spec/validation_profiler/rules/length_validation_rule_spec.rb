RSpec.describe ValidationProfiler::Rules::LengthValidationRule do

  describe '#validate' do

    it 'should skip validation when not required and field value is nil' do
      test_obj = TestObject.new
      test_obj.text = nil
      expect(subject.validate(test_obj, :text, { min: 5, required: false })).to eq(true)
    end

    it 'should correctly validate a 6 character string as having a minimum of 5 characters' do
      test_obj = TestObject.new
      test_obj.text = '123456'
      expect(subject.validate(test_obj, :text, { min: 5 })).to eq(true)
    end

    it 'should correctly validate a 6 character string as having a minimum of 5 characters and a max of 8 characters' do
      test_obj = TestObject.new
      test_obj.text = '123456'
      expect(subject.validate(test_obj, :text, { min: 5, max: 8 })).to eq(true)
    end

    it 'should fail to validate a 4 character string as having a minimum of 5 characters' do
      test_obj = TestObject.new
      test_obj.text = '1234'
      expect(subject.validate(test_obj, :text, { min: 5 })).to eq(false)
    end

    it 'should fail to validate a 9 character string as having a maximum of 8 characters' do
      test_obj = TestObject.new
      test_obj.text = '123456789'
      expect(subject.validate(test_obj, :text, { max: 8 })).to eq(false)
    end

    it 'should fail to validate a 9 character string as having a minimum of 5 characters and a maximum of 8 characters' do
      test_obj = TestObject.new
      test_obj.text = '123456789'
      expect(subject.validate(test_obj, :text, { min: 5,  max: 8 })).to eq(false)
    end

    it 'should fail to validate a 4 character string as having a minimum of 5 characters and a maximum of 8 characters' do
      test_obj = TestObject.new
      test_obj.text = '1234'
      expect(subject.validate(test_obj, :text, { min: 5,  max: 8 })).to eq(false)
    end

    it 'should correctly validate an array with 2 items as having a minimum length of 1' do
      test_obj = TestObject.new
      test_obj.array = [1,2]
      expect(subject.validate(test_obj, :array, { min: 1 })).to eq(true)
    end

    it 'should fail to validate an array with 2 items as having a minimum length of 3' do
      test_obj = TestObject.new
      test_obj.array = [1,2]
      expect(subject.validate(test_obj, :array, { min: 3 })).to eq(false)
    end

    it 'should correctly validate an array with 2 items as having a maximum length of 3' do
      test_obj = TestObject.new
      test_obj.array = [1,2]
      expect(subject.validate(test_obj, :array, { max: 3 })).to eq(true)
    end

    it 'should fail to validate an array with 2 items as having a maximum length of 1' do
      test_obj = TestObject.new
      test_obj.array = [1,2]
      expect(subject.validate(test_obj, :array, { max: 1 })).to eq(false)
    end

    it 'should correctly validate an array with 2 items as having a minimum length of 1 and a maximum length of 3' do
      test_obj = TestObject.new
      test_obj.array = [1,2]
      expect(subject.validate(test_obj, :array, { min: 1, max: 3 })).to eq(true)
    end

    it 'should fail to validate an array with 4 items as having a minimum length of 1 and a maximum length of 3' do
      test_obj = TestObject.new
      test_obj.array = [1,2,3,4]
      expect(subject.validate(test_obj, :array, { min: 1, max: 3 })).to eq(false)
    end

  end

  describe '#error_message' do

    it 'should return the default error message for min & max when no custom message has been specified' do
      expect(subject.error_message(:text, { min: 2, max: 5 })).to eq('text must have a min length of 2 and a max length of 5')
    end

    it 'should return the default error message for min when no custom message has been specified' do
      expect(subject.error_message(:text, { min: 2 })).to eq('text must have a min length of 2')
    end

    it 'should return the default error message for max when no custom message has been specified' do
      expect(subject.error_message(:text, { max: 5 })).to eq('text must have a max length of 5')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:text, { max: 5, message: 'text should have no more than 5 characters' })).to eq('text should have no more than 5 characters')
    end

  end

end