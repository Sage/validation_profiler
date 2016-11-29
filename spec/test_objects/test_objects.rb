class MinLengthTestProfile
  extend ValidationProfiler

  validates :text, :length, { min: 5 }
end

class TestObject
  attr_accessor :text
  attr_accessor :numeric
  attr_accessor :date
  attr_accessor :datetime
  attr_accessor :array
  attr_accessor :email
  attr_accessor :confirm
  attr_accessor :nested1
  attr_accessor :nested2
end

class ChildTestObject
  attr_accessor :text
  attr_accessor :numeric
end

class CustomRequiredValidationRule < ValidationProfiler::Rules::RequiredValidationRule

end

class MultipleRuleTestProfile
  validates :text, :required
  validates :numeric, :min, { :value => 5 }
end

class MultipleRuleTestProfile2
  validates :text, :length, {min: 36, max: 36, required: true }
  validates :numeric, :min, { :value => 5 }
end

class ChildRuleTestProfile
  validates :text, :required
  validates :nested1, :child, { :profile => MultipleRuleTestProfile, :required => true }
  validates :nested2, :child, { :profile => MultipleRuleTestProfile2, :required => true }
end