class Api::V1::BaseController < ApplicationController
  include ErrorsAllHelper

  BAD_REQUEST_STATUS_CODE = 400
  VALIDATION_ERROR_CODE = 422

  # before_action :add_deprecation_to_header
  # before_action :add_disabled_to_header
  before_action :add_active_status_to_header
  before_action :check_format

  rescue_from ArgumentError, with: :argument_out_of_range
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActionController::RoutingError, with: :no_route_matches
  rescue_from ActionController::ParameterMissing, with: :invalid_params

  private

  def json_error_with_params(errors, fields)
    render status: VALIDATION_ERROR_CODE,
           json: {error: {
             messages: errors,
             fields: fields
           }}
  end

  def check_format
    unless request.format == :json
      render status: 406, json: {error: {
        messages: ["The request must be json."],
        fields: []
      }}
    end
  end

  def record_not_found(exception)
    render status: 404, json: {error: {
      messages: [exception.message],
      fields: []
    }}
  end

  def invalid_params(exception)
    render status: BAD_REQUEST_STATUS_CODE, json: {error: {
      messages: [exception.message],
      fields: []
    }}
  end

  def no_route_matches(exception)
    render status: 404, json: {error: {
      messages: [exception.message],
      fields: []
    }}
  end


  def argument_out_of_range(exception)
    render status: 400, json: {error: {
      messages: [exception.message],
      fields: []
    }}
  end

  def record_invalid(exception)
    record = exception.record

    messages = record.errors.full_messages
    fields = errors_fields(record)

    render status: VALIDATION_ERROR_CODE, json: {error: {
      messages: messages,
      fields: fields
    }}
  end

  def add_deprecation_to_header
    response.headers['API-Status'] = 'Deprecated'
  end

  def add_disabled_to_header
    response.headers['API-Status'] = 'Disabled'
  end

  def add_active_status_to_header
    response.headers['API-Status'] = 'Actual'
  end
end
