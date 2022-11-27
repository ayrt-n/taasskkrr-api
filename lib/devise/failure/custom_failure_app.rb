class CustomFailureApp < Devise::FailureApp
  def respond
    if request.format == :json
      json_error_response
    else
      super
    end
  end

  private

  def json_error_response
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = {
      error: {
        status: '401',
        title: 'Unauthorized',
        details: [i18n_message]
      }
    }.to_json
  end
end
