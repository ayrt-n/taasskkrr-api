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
          status: '422',
          title: 'Unprocessable Entity',
          details: resource.errors
        }
      ]
    }, status: :unprocessable_entity
  end

  def not_found
    render json: {
      errors: [
        status: '404',
        title: 'Not Found'
      ]
    }, status: :not_found
  end
end
