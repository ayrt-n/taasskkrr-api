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
      error: {
        status: '422',
        title: 'Unprocessable Entity',
        details: resource.errors.full_messages
      }
    }, status: :unprocessable_entity
  end

  def not_found
    render json: {
      error: {
        status: '404',
        title: 'Not Found',
        details: 'The requested page could not be found.'
      }
    }, status: :not_found
  end

  def access_denied
    render json: {
      error: {
        status: '401',
        title: 'Access denied',
        details: 'You do not have the correct permissions.'
      }
    }, status: :unauthorized
  end
end
