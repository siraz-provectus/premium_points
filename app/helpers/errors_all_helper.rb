module ErrorsAllHelper
  # @param [ActiveRecord::Base] model
  def errors_fields(model)
    model.errors.keys
  end
end