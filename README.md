# ValidationProfiler

Welcome to ValidationProfiler. This is a validation framework that allows you to seperate validation logic away from your objects and into validation profiles that can be re-used and changed without affecting your objects.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'validation_profiler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install validation_profiler

## Usage

First you need to create a validation profile to hold the validation logic you want to apply, validation profiles must inherit from the ValidationProfile base class or another validation profile.

    class SignUpValidationProfile < ValidationProfile
	    .....
    end

Then you specify validation rules that should be checked when this profile is validated against an object.

    class SignUpValidationProfile
        extend ValidationProfiler

	    validates :age, :min, { value: 18 }
	    validates :email, :email
	    .....
    end

When specifying a validation rule you need to specify the following arguments:

 - Field name
 - Rule key
 - Hash containing any options required for the validation rule

So if we take another look at the first validation rule we specified in the **SignUpValidationProfile** above:

	Field name = :age
	Rule key = :min
	Attributes Hash = { value: 18 }

This validation statement will be interpreted as:
*"The field :age must have a minimum value of 18"*

To use a validation profile you need to make a call to the **ValidationManager** class, and pass the object you want to validate along with the profile you want to use for the validation:

    #create the validation manager
    manager = ValidationManager.new

    #call the validate method and pass the object and profile
    result = manager.validate(user, profile)

Calls to the validate method will return a **ValidationManagerResult** that will detail the results of the validation.

A **ValidationManagerResult** has the following attributes:

 - #outcome = [Boolean] overall outcome of the validation (passed or failed)
 - #errors = [Array] containing details of each field error that occurred during validation.

Each item in the errors array has the following attributes:

 - #field = The name of the field that this error occurred for.
 - #message = A message that describes the validation error

## Validation Rules

**RequiredValidationRule**

This rule is used to specify a field must contain a value:

    validates :name, :required

Attributes:

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.


----------

#
**LengthValidationRule**

This rule is used to specify a [String] or [Array] must be of a certain length:

    validates :name, :length, { min: 5, max: 10 }

Attributes:

 - **:min** [Numeric]
 This is used to specify the minimum length of the field value.

 - **:max** [Numeric]
 This is used to specify the maximum length of the field value.

 > **:min** & **:max** can be included together or independently providing at least 1 is specified.

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)


----------

#
**MinValidationRule**

This rule is used to specify a minimum value a [DateTime] or [Numeric] field must have.

    validates :age, :min, { value: 18 }

Attributes:

 - **:value** [Numeric/DateTime]
 This is used to specify the minimum value of the field.

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
	 This is used to specify if this rule should only be executed when the field contains a value.
> **True** always executes, **False** only executes when the field contains a value)*

----------

#
**MaxValidationRule**

This rule is used to specify a maximum value a [DateTime] or [Numeric] field must have.

    validates :age, :max, { value: 25 }

Attributes:

 - **:value** [Numeric/DateTime]
 This is used to specify the maximum value of the field.

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed the field contains a value.
> **True** always executes, **False** only executes when the field contains a value)

----------

#
**EmailValidationRule**

This rule is used to specify a field value must contain a valid email address.

    validates :email_address, :email

Attributes:

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
> **True** always executes, **False** only executes when the field contains a value)

----------

#
**RegexValidationRule**

This rule is used to specify a regex pattern that a field value must validate against.

    validates :email, :regex, { regex: /^[^@]+@[^@]+\.[^@]+$/ }

Attributes:

 - **:regex** [Regex]
This is used to specify the regex pattern.

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
> **True** always executes, **False** only executes when the field contains a value)

----------

#
**MatchValidationRule**

This rule is used to specify a field value must match the value of another field.

    validates :confirm_password, :match, { field: :password }

Attributes:

 - **:field** [Symbol]
This is used to specify the name of the other field this field's value must match.

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)

----------

#
**ConditionValidationRule**

This rule is used to specify a condition statement.

e.g.

> format:
>
> When [:condition_field] [:condition_expression] [:condition_value] then [:field] [:field_expression] [:field_value]
>
>could be read as:
>
> When :age >= 18 then :accept == true

    validates :accept, :condition, { condition_field: :age, condition_expression: '>=', condition_value: 18, field_expression: '==', field_value: true }

Attributes:

 - **:condition_field** [Symbol]
This is used to specify the name of the condition field.

 - **:condition_expression** [String]
This is used to specify the expression to use between the condition_field and the condition_value.

> **Supported expression types:**
> '=='
> '>'
> '>='
> '<'
> '<='
> '!='


 - **:condition_value** [String/Numeric/DateTime/nil]
This is used to specify the value to use for the condition statement.

 - **:field_expression** [String]
This is used to specify the expression to use between the field's value and the field_value attribute.

 - **:field_value** [String/Numeric/DateTime/nil]
This is used to specify the value to use for the field statement.

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)

---------

#
**NotAllowedValidationRule**

This rule is used to specify a field must not contain a value:

    validates :hidden, :not_allowed

 Attributes:

  - **:message** [String] [Optional]
  This is used to allow a custom error message to be specified.

---------

#
**ListValidationRule**

This rule is used to specify a field value must be within a specified list of accepted values:

    validates :name, :list, { list: ['dog','cat','rabbit'] }

Attributes:

 - **:list** [Array]
 This is used to specify the list of values that are acceptable for this field.

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)

----------

#
**ChildValidationRule**

This rule is used to specify a field with a child object should validate against another validation profile:

    validates :address, :child, { profile: AddressValidationProfile }

Attributes:

 - **:profile** [Class]
 This is used to specify the validation profile to use for the nested child object

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)


------------

#
**IntegerValidationRule**

This rule is used to specify a field must be a valid Integer

    validates :age, :int, { required: false }

Attributes:

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)

----------

#
**DecimalValidationRule**

This rule is used to specify a field must be a valid Decimal

    validates :amount, :decimal, { required: false }

Attributes:

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)

----------

#
**DateValidationRule**

This rule is used to specify a field must be a valid Date

    validates :dob, :date, { required: false }

Attributes:

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)

----------

#
**TimeValidationRule**

This rule is used to specify a field must be a valid Time. Value can be either full datetime '12-Mar-2016 12:30:10' or seconds since epoch 1476344603.

    validates :updated, :time, { required: false }

Attributes:

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)

----------

#
**GuidValidationRule**

This rule is used to specify a field must be a valid Guid.

    validates :id, :guid, { hyphens: true, brackets: true, required: true }

Attributes:

 - **:hyphens** [Boolean] [Default=false] [Optional]
  This is used to allow a the guid value to contain hyphens.

 - **:brackets** [Boolean] [Default=false] [Optional]
 This is used to allow a the guid value to contain brackets. Both ( & { brackets are supported.

 - **:message** [String] [Optional]
 This is used to allow a custom error message to be specified.

 - **:required** [Boolean] [Default=True] [Optional]
 This is used to specify if this rule should only be executed when the field contains a value.
 > **True** always executes, **False** only executes when the field contains a value)

----------

##Custom Validation Rules

To create a custom validation rule you must create a class that inherits from the **ValidationRule** base class and implement the #error_message and #validate methods, see the **RequiredValidationRule** below as an example:

    class RequiredValidationRule < ValidationRule
	    #implement this method to return the error message when
	    #this rule fails validation
	    def error_message(field, attributes = {})
		    #check if custom message was specified
		    if attributes[:message] == nil
			    #return default method
		      "#{field} is not valid"
		    else
			    #return custom message
		      attributes[:message]
		    end
		end

		def validate(obj, field, attributes = {})
			#attempt to get the field value from the object
			field_value = get_field_value(obj, field)

			if field_value == nil
		      return false
		    end

		    return !field_value.empty?
		end
    end

The **ValidationRule** base class provides the `#get_field_value(obj, field)` method to cater for fetching the field value from the object to perform the validation against.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sage/validation_profiler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

This gem is available as open source under the terms of the
[MIT licence](LICENSE).

Copyright (c) 2018 Sage Group Plc. All rights reserved.
