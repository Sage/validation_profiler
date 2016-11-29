RSpec.describe ValidationProfiler::Rules::DecimalValidationRule do

  describe '#validate' do

    context 'when a valid decimal is specified' do
      context 'that is an int' do
        it 'should return true' do
          obj = { decimal: 5 }
          expect(subject.validate(obj, :decimal)).to eq(true)
        end
      end
      context 'that is a string' do
        it 'should return true' do
          obj = { decimal: '5.05' }
          expect(subject.validate(obj, :decimal)).to eq(true)
        end
      end
      context 'that is a decimal' do
        it 'should return true' do
          obj = { decimal: 5.05 }
          expect(subject.validate(obj, :decimal)).to eq(true)
        end
      end
    end

    context 'when an invalid decimal is specified' do
      it 'should return false' do
        obj = { decimal: 'abc' }
        expect(subject.validate(obj, :decimal)).to eq(false)
      end
    end

    context 'when no value is specified but is required' do
      it 'should return false' do
        obj = {}
        expect(subject.validate(obj, :decimal, { required: true })).to eq(false)
      end
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:amount)).to eq('amount is not a valid Decimal')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:time, { message: 'Please enter a valid Decimal' })).to eq('Please enter a valid Decimal')
    end

  end

end