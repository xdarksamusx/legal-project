class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:check]

  def check
    if request.get?
      if user_signed_in?
        render json: { user: current_user }, status: :ok
      else
        render json: { error: 'Not signed in' }, status: :unauthorized
      end
    elsif request.post?
      Rails.logger.info("Received POST /session.user with params: #{params.inspect}")
      # Redirect to the correct sign-in endpoint
      user_params = params[:user] || {}
      user = User.find_for_authentication(email: user_params[:email])
      if user&.valid_password?(user_params[:password])
        sign_in(:user, user)
        redirect_to "http://localhost:3001/disclaimer"
      else
        redirect_to new_user_session_path, alert: "Invalid email or password"
      end
    else
      render json: { error: 'Method not allowed' }, status: :method_not_allowed
    end
  end
end