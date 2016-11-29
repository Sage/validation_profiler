RSpec.describe ValidationProfiler::Rules::IntegerValidationRule do

  describe '#validate' do

    context 'when a valid integer is specified' do
      context 'that is an int' do
        it 'should return true' do
          obj = { int: 5 }
          expect(subject.validate(obj, :int)).to eq(true)
        end
      end
      context 'that is a string' do
        it 'should return true' do
          obj = { int: '5' }
          expect(subject.validate(obj, :int)).to eq(true)
        end
      end
    end

    context 'when an invalid int is specified' do
      it 'should return false' do
        obj = { int: 'abc' }
        expect(subject.validate(obj, :int)).to eq(false)
      end
    end

    context 'when no value is specified but is required' do
      it 'should return false' do
        obj = {}
        expect(subject.validate(obj, :int, { required: true })).to eq(false)
      end
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:number)).to eq('number is not a valid Integer')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:time, { message: 'Please enter a valid Integer' })).to eq('Please enter a valid Integer')
    end

  end

end