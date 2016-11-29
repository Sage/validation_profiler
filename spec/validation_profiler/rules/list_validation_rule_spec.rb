RSpec.describe ValidationProfiler::Rules::ListValidationRule do

  context '#validate' do

    it 'should fail when a text value is not within the specified list' do

      hash = { :text => 'bird' }
      expect(subject.validate(hash, :text, { :list => ['dog', 'cat', 'rabbit'] })).to eq(false)

    end

    it 'should fail when a numeric value is not within the specified list' do

      hash = { :numeric => 10 }
      expect(subject.validate(hash, :numeric, { :list => [2, 4, 6] })).to eq(false)

    end

    it 'should pass when a text value is within the specified list' do

      hash = { :text => 'cat' }
      expect(subject.validate(hash, :text, { :list => ['dog', 'cat', 'rabbit'] })).to eq(true)

    end

    it 'should pass when a numeric value is within the specified list' do

      hash = { :text => 4 }
      expect(subject.validate(hash, :text, { :list => [2, 4, 6] })).to eq(true)

    end

  end

  context '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:text)).to eq('text is not an accepted value.')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:text, { message: 'Please make sure that text is an accepted value.' })).to eq('Please make sure that text is an accepted value.')
    end

  end

end