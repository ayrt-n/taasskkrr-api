module Api
  module V1
    class PasswordsController < Devise::PasswordsController
      respond_to :json

      def create
        self.resource = resource_class.send_reset_password_instructions(resource_params)
        yield resource if block_given?

        render_resource(resource)
      end

      def update
        self.resource = resource_class.reset_password_by_token(resource_params)
        yield resource if block_given?

        render_resource(resource)
      end
    end
  end
end
