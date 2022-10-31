class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          details: resource.errors
        }
      ]
    }, status: :bad_request
  end

  def not_found
    render json: {
      errors: [
        status: '404',
        title: 'Not Found'
      ]
    }, status: 404
  end
end
