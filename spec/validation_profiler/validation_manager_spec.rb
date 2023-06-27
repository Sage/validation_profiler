require 'securerandom'

RSpec.describe ValidationProfiler::Manager do
  it 'should return a pass outcome when an object is valid for the profile' do
    obj = TestObject.new
    obj.text = '123456'
    expect(subject.validate(obj, MinLengthTestProfile).outcome).to eq(true)
  end

  it 'should return a fail outcome when an object is not valid for the profile' do
    obj = TestObject.new
    obj.text = '1234'
    result = subject.validate(obj, MinLengthTestProfile)
    expect(result.outcome).to eq(false)
    expect(result.errors.length).to eq(1)
  end

  it 'should return a pass outcome when an object is valid for the profile' do
    obj = TestObject.new
    obj.text = '123456'
    obj.numeric = 6
    expect(subject.validate(obj, MultipleRuleTestProfile).outcome).to eq(true)
  end

  it 'should return a fail outcome when an object is not valid for the profile due to :required failing' do
    obj = TestObject.new
    obj.text = nil
    obj.numeric = 6
    expect(subject.validate(obj, MultipleRuleTestProfile).outcome).to eq(false)
  end

  context '#add_rule'  do
    it 'should add a valid rule and use it to validate' do
      manager = ValidationProfiler::Manager.new
      manager.add_rule(:custom_required, CustomRequiredValidationRule)
      expect(manager.validate(TestObject.new, CustomRuleTestProfile).outcome).to eq(false)
    end

    it 'will instantiate a rules manager instance if it is not set' do
      ValidationProfiler::Rules::Manager.instance = nil
      subject.add_rule(:custom_required, CustomRequiredValidationRule)
      expect(ValidationProfiler::Rules::Manager.instance).not_to be_nil
    end
  end

  context ValidationProfiler::Rules::ChildValidationRule do
    it 'should fail when a nested property is nil' do
      obj = TestObject.new
      obj.text = 'abc'
      obj.nested1 = nil
      obj.nested2 = nil
      manager = ValidationProfiler::Manager.new
      expect(manager.validate(obj, ChildRuleTestProfile).outcome).to eq(false)
    end

    it 'should fail when a nested property fails validation' do
      obj = TestObject.new
      obj.text = 'abc'
      obj.nested1 = ChildTestObject.new
      obj.nested1.text = 'abc'
      obj.numeric = 6
      obj.nested2 = ChildTestObject.new
      obj.nested2.text = SecureRandom.uuid
      manager = ValidationProfiler::Manager.new
      result = manager.validate(obj, ChildRuleTestProfile)
      expect(result.outcome).to eq(false)
      expect(result.errors.length).to eq(2)
      expect(result.errors[0][:field]).to eq(:numeric)
    end

    it 'should pass when a nested property passes validation' do
      obj = TestObject.new
      obj.text = 'abc'
      obj.nested1 = ChildTestObject.new
      obj.nested1.text = SecureRandom.uuid
      obj.nested1.numeric = 6
      obj.nested2 = ChildTestObject.new
      obj.nested2.text = SecureRandom.uuid
      obj.nested2.numeric = 6
      manager = ValidationProfiler::Manager.new
      result = manager.validate(obj, ChildRuleTestProfile)
      expect(result.outcome).to eq(true)
    end

    describe 'field value is an array' do
      let(:identifier) { SecureRandom.uuid.delete('-') }
      let(:text) { SecureRandom.hex(5) }
      let(:nested_1) { double(text: text, numeric: 6) }
      let(:nested_2) { double(text: text, numeric: 7) }
      let(:nested_array) { [nested_1, nested_2] }
      let(:hash) { { identifier: identifier, nested: nested_array } }

      context 'valid' do
        it 'correctly validates an array of child objects' do
          manager = ValidationProfiler::Manager.new
          result = manager.validate(hash, ChildArrayRuleTestProfile)

          expect(result.outcome).to eq(true)
        end

        context 'but a property has failed validation' do
          let(:identifier) { '' }

          it 'fails validation' do
            manager = ValidationProfiler::Manager.new
            result = manager.validate(hash, ChildArrayRuleTestProfile)

            expect(result.outcome).to eq(false)
            expect(result.errors.count).to eq(1)
          end
        end
      end

      context 'invalid' do
        let(:text) { '' }

        it 'correctly validates an array of child objects' do
          manager = ValidationProfiler::Manager.new
          result = manager.validate(hash, ChildArrayRuleTestProfile)

          expect(result.outcome).to eq(false)
        end

        it 'returns array of validation errors per invalid object' do
          manager = ValidationProfiler::Manager.new
          result = manager.validate(hash, ChildArrayRuleTestProfile)

          expect(result.outcome).to eq(false)
          expect(result.errors.count).to eq 2
        end

        context 'and a previous property has failed validation' do
          let(:identifier) { '' }

          it 'fails validation and returns all errors' do
            manager = ValidationProfiler::Manager.new
            result = manager.validate(hash, ChildArrayRuleTestProfile)

            expect(result.outcome).to eq(false)
            expect(result.errors.count).to eq 3
          end
        end
      end
    end
  end
end
