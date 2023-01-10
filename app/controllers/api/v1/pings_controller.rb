class PingsController < ApplicationController
  def ping
    render json: { message: "Okay, okay, I'm up!" }
  end
end
