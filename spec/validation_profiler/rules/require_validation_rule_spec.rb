RSpec.describe ValidationProfiler::Rules::RequiredValidationRule do

  describe '#validate' do

    it "should correctly validate a string of 'hello' as required" do
      test_obj = TestObject.new
      test_obj.text = 'hello'
      expect(subject.validate(test_obj, :text)).to eq(true)
    end

    it 'should fail to validate an empty string as required' do
      test_obj = TestObject.new
      test_obj.text = ''
      expect(subject.validate(test_obj, :text)).to eq(false)
    end

    it 'should fail to validate an nil attribute as required' do
      test_obj = TestObject.new
      test_obj.text = nil
      expect(subject.validate(test_obj, :text)).to eq(false)
    end

    it 'should correctly validate an array with 2 items as required' do
      test_obj = TestObject.new
      test_obj.array = [1,2]
      expect(subject.validate(test_obj, :array)).to eq(true)
    end

    it 'should fail to validate an empty array as required' do
      test_obj = TestObject.new
      test_obj.array = []
      expect(subject.validate(test_obj, :array)).to eq(false)
    end

    it 'should fail to validate a nil field as required' do
      test_obj = TestObject.new
      test_obj.text = nil
      expect(subject.validate(test_obj, :text)).to eq(false)
    end

    it 'should correctly validate a Fixnum as required when present' do
      test_obj = TestObject.new
      test_obj.numeric = 1
      expect(subject.validate(test_obj, :numeric)).to eq(true)
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:text)).to eq('text is required')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:text, { message: 'Please enter a value for text' })).to eq('Please enter a value for text')
    end

  end

end