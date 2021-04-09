class ApplicationController < ActionController::API
  rescue_from ActiveRecord::StatementInvalid, with: :render_bad_parameters
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_bad_parameters
  rescue_from ArgumentError, with: :render_bad_parameters

  def render_bad_parameters(error)
    render json: ErrorSerializer.new(error), status: :bad_request
  end
  
  def render_not_found(error)
    render json: ErrorSerializer.new(error), status: :not_found
  end
end
