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

    end
end