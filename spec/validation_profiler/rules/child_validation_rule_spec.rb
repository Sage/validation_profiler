RSpec.describe ValidationProfiler::Rules::ChildValidationRule do

  context '#validate' do

    it 'should raise an InvalidRuleAttributes exception when a profile attribute is not specified' do

      hash = { :nested => ChildTestObject.new }
      expect{ subject.validate(hash, :nested, {}) }.to raise_error(ValidationProfiler::Exceptions::InvalidValidationRuleAttributes)

    end

    it 'should fail when the nested object fails validation' do

      hash = { :nested => ChildTestObject.new }
      result = subject.validate(hash, :nested, { profile: MultipleRuleTestProfile2 })
      expect(result.outcome).to be false
      expect(result.errors[0][:field]).to eq(:text)
      expect(result.errors[1][:message]).to eq('nested.numeric must have a minimum value of 5')

    end

    it 'should fail when the nested object fails validation' do

      child = ChildTestObject.new
      child.text = 'abcdef'
      child.numeric = 6
      hash = { :nested => child }
      result = subject.validate(hash, :nested, { profile: MultipleRuleTestProfile2 })
      expect(result.outcome).to be false
      expect(result.errors[0][:field]).to eq(:text)

    end

    it 'should pass validation when the nested object is valid' do

      nested = ChildTestObject.new
      nested.text= 'abc'
      nested.numeric = 6

      hash = { :nested => nested }
      result = subject.validate(hash, :nested, { profile: MultipleRuleTestProfile })
      expect(result.outcome).to be true

    end
  end

end