RSpec.describe ValidationProfiler::Rules::DateValidationRule do

  describe '#validate' do

    context 'when a valid date is specified' do
      context 'and the value is mixed case' do
        it 'should return true' do
          test_obj = TestObject.new
          test_obj.date = '12-Mar-2015'
          expect(subject.validate(test_obj, :date)).to eq(true)
        end
      end
      context 'and the value is lower case' do
        it 'should return true' do
          test_obj = TestObject.new
          test_obj.date = '12-mar-2015'
          expect(subject.validate(test_obj, :date)).to eq(true)
        end
      end
      context 'and the value is upper case' do
        it 'should return true' do
          test_obj = TestObject.new
          test_obj.date = '12-MAR-2015'
          expect(subject.validate(test_obj, :date)).to eq(true)
        end
      end
    end

    context 'when an invalid date is specified' do
      it 'should return false' do
        test_obj = TestObject.new
        test_obj.date = 'abc'
        expect(subject.validate(test_obj, :date)).to eq(false)
      end
    end

    context 'when no value is specified but is required' do
      it 'should return false' do
        obj = {}
        expect(subject.validate(obj, :date, { required: true })).to eq(false)
      end
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:date)).to eq('date is not a valid date')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:date, { message: 'Please enter a valid date' })).to eq('Please enter a valid date')
    end

  end

end