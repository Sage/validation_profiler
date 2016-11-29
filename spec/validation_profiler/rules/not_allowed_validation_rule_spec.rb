RSpec.describe ValidationProfiler::Rules::NotAllowedValidationRule do

  context '#validate' do

    it 'should fail when a hash contains a not allowed field' do

      hash = { :text => 'abc123' }
      expect(subject.validate(hash, :text)).to eq(false)

    end

    it 'should fail when an object contains a not allowed field' do

      test_obj = TestObject.new
      test_obj.text = 'abc123'
      expect(subject.validate(test_obj, :text)).to eq(false)

    end

    it 'should pass when a hash does not contain a not allowed field' do

      hash = { :text2 => 'abc123' }
      expect(subject.validate(hash, :text)).to eq(true)

    end

    it 'should fail when an object does not contain a value for a not allowed field' do

      test_obj = TestObject.new
      test_obj.numeric = 12
      expect(subject.validate(test_obj, :text)).to eq(true)

    end

  end

  context '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:text)).to eq('text is not allowed.')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:text, { message: 'Please make sure that text is not specified.' })).to eq('Please make sure that text is not specified.')
    end

  end

end