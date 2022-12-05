module Api
  module V1
    class ConfirmationsController < Devise::ConfirmationsController
      respond_to :json

      def create
        self.resource = resource_class.send_confirmation_instructions(resource_params)
        yield resource if block_given?

        render_resource(resource)
      end

      def show
        self.resource = resource_class.confirm_by_token(params[:confirmation_token])
        yield resource if block_given?

        render_resource(resource)
      end
    end
  end
end
