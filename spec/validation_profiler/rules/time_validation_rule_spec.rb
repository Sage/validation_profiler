require 'time'

RSpec.describe ValidationProfiler::Rules::TimeValidationRule do

  describe '#validate' do

    context 'when a valid time is specified' do
      context 'and the value is mixed case' do
        it 'should return true' do
          obj = { time: '12-Mar-2015 12:30:00' }
          expect(subject.validate(obj, :time)).to eq(true)
        end
      end
      context 'and the value is lower case' do
        it 'should return true' do
          obj = { time: '12-mar-2015 12:30:00' }
          expect(subject.validate(obj, :time)).to eq(true)
        end
      end
      context 'and the value is upper case' do
        it 'should return true' do
          obj = { time: '12-MAR-2015 12:30:00' }
          expect(subject.validate(obj, :time)).to eq(true)
        end
      end
      context 'and the value is Int seconds since epoch' do
        it 'should return true' do
          obj = { time: 1476344603 }
          expect(subject.validate(obj, :time)).to eq(true)
        end
      end
      context 'and the value is String seconds since epoch' do
        it 'should return true' do
          obj = { time: '1476344603' }
          expect(subject.validate(obj, :time)).to eq(true)
        end
      end
    end

    context 'when an invalid time is specified' do
      it 'should return false' do
        obj = { time: 'abc123' }
        expect(subject.validate(obj, :time)).to eq(false)
      end
    end

    context 'when no value is specified but is required' do
      it 'should return false' do
        obj = {}
        expect(subject.validate(obj, :time, { required: true })).to eq(false)
      end
    end

  end

  describe '#error_message' do

    it 'should return the default error message when no custom message has been specified' do
      expect(subject.error_message(:time)).to eq('time is not a valid time')
    end

    it 'should return a custom error message when one has been specified' do
      expect(subject.error_message(:time, { message: 'Please enter a valid time' })).to eq('Please enter a valid time')
    end

  end

end
