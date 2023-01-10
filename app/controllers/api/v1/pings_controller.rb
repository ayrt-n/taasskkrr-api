module Api
  module V1
    class PingsController < ApplicationController
      def ping
        render json: { message: "Okay, okay, I'm up!" }
      end
    end
  end
end
