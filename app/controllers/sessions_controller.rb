class SessionsController < ApplicationController

  skip_before_action :verify_authenticity_token, only: [:csrf_token]

  def check
    if user_signed_in?
      render json: {
        session: true,
        user: {
          id: current_user.id,
          email: current_user.email,
          username: current_user.username
        }
      }, status: :ok
    else
      render json: { session: false, user: nil }, status: :unauthorized
    end
  end

  def csrf_token
    render json: { csrf_token: form_authenticity_token }, status: :ok
  end
end