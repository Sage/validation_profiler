RSpec.describe ValidationProfiler::Rules::ChildValidationRule do
  context '#validate' do
    it 'should raise an InvalidRuleAttributes exception when a profile attribute is not specified' do
      hash = { nested: ChildTestObject.new }
      expect { subject.validate(hash, :nested, {}) }
        .to raise_error(ValidationProfiler::Exceptions::InvalidValidationRuleAttributes)
    end

    it 'should fail when the nested object fails validation' do
      hash = { nested: ChildTestObject.new }
      result = subject.validate(hash, :nested, profile: MultipleRuleTestProfile2)
      expect(result.outcome).to be false
      expect(result.errors[0][:field]).to eq(:text)
      expect(result.errors[1][:message]).to eq('nested.numeric must have a minimum value of 5')
    end

    it 'should fail when the nested object fails validation' do
      child = ChildTestObject.new
      child.text = 'abcdef'
      child.numeric = 6
      hash = { nested: child }
      result = subject.validate(hash, :nested, profile: MultipleRuleTestProfile2)
      expect(result.outcome).to be false
      expect(result.errors[0][:field]).to eq(:text)
    end

    it 'should pass validation when the nested object is valid' do
      nested = ChildTestObject.new
      nested.text = 'abc'
      nested.numeric = 6

      hash = { nested: nested }
      result = subject.validate(hash, :nested, profile: MultipleRuleTestProfile)
      expect(result.outcome).to be true
    end

    context 'field value is an array' do
      let(:text) { 'abc' }
      let(:nested_1) { double(text: text, numeric: 6) }
      let(:nested_2) { double(text: 'def', numeric: 7) }
      let(:nested_array) { [nested_1, nested_2] }
      let(:hash) { { nested: nested_array } }
      let(:validation_profile) { MultipleRuleTestProfile }

      it 'returns an array of results' do
        result = subject.validate(hash, :nested, profile: validation_profile)

        expect(result).to be_an(Array)
        expect(result.length).to eq 2
      end

      context 'valid' do
        it 'validates an array of child objects' do
          result = subject.validate(hash, :nested, profile: validation_profile)

          expect(result[0].outcome).to be true
          expect(result[1].outcome).to be true
        end
      end

      context 'invalid' do
        let(:text) { '' }

        it 'validates an array of child objects' do
          result = subject.validate(hash, :nested, profile: validation_profile)

          expect(result[0].outcome).to be false
          expect(result[1].outcome).to be true
        end
      end

      context 'is required' do
        let(:validation_profile) { ChildArrayRuleTestProfile }

        context 'when empty array' do
          let(:nested_array) { [] }

          it 'returns false' do
            result = subject.validate(hash, :nested, profile: validation_profile)

            expect(result).to be false
          end
        end

        context 'when nil' do
          let(:nested_array) { nil }

          it 'returns false' do
            result = subject.validate(hash, :nested, profile: validation_profile)

            expect(result).to be false
          end
        end
      end
    end
  end
end
