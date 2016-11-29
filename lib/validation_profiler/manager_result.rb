module ValidationProfiler
  # This is used to specify validation results from the #validate method of the Validation Manager
  class ManagerResult

    # @!attribute outcome
    #   @return [Boolean] The outcome of the validation.
    attr_accessor :outcome
    # @!attribute errors
    #   @return [Array[{:field, :error_message}]] An array of field errors that occurred during validation.
    attr_accessor :errors

    def initialize
      @errors = []
      @outcome = true
    end
  end
end