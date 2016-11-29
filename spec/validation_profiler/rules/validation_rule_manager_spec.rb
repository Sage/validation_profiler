describe ValidationProfiler::Rules::Manager do

  describe '#get_rule' do

    it 'should raise a ValidationRuleNotFound exception when an invalid validation rule is requested' do

      expect{ subject.get_rule(:invalid_rule) }.to raise_error(ValidationProfiler::Exceptions::ValidationRuleNotFound)

    end

    it 'should return a rule when a valid rule is requested' do
      rule = subject.get_rule(:length)
      expect(rule).to be_a(ValidationProfiler::Rules::LengthValidationRule)
    end

  end

  describe '#add_rule' do

    it 'should add a valid rule' do

      subject.add_rule(:custom_required, CustomRequiredValidationRule)
      rule = subject.get_rule(:custom_required)
      expect(rule).to_not eq(nil)

    end

    it "should raise an 'InvalidValidationRuleType' exception when attempting to add an rule that doesn't inherit from 'ValidationRule'" do

      expect { subject.add_rule(:custom_required, TestObject) }.to raise_error(ValidationProfiler::Exceptions::InvalidValidationRuleType)

    end

    it "should raise a 'RuleAlreadyExists' when attempting to add a rule for a key that has already been registered" do

      expect { subject.add_rule(:required, CustomRequiredValidationRule) }.to raise_error(ValidationProfiler::Exceptions::ValidationRuleAlreadyExists)

    end

  end

end