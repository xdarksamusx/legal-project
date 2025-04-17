class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:create]
  respond_to :html, :json

  def new
    respond_to do |format|
      format.html do
        if user_signed_in?
          redirect_to disclaimer_path # Redirect to /disclaimer instead of root_path
        else
          super # Renders devise/sessions/new.html.erb
        end
      end
      format.json do
        render json: { error: 'You must sign in to access this resource' }, status: :unauthorized
      end
    end
  end

  def create
    user = User.find_by(email: params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      sign_in(user)
      user.remember_me = params[:user][:remember_me] if params[:user][:remember_me]
      respond_to do |format|
        format.html { redirect_to after_sign_in_path_for(user) }
        format.json { render json: { user: { id: user.id, email: user.email, username: user.username } }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unauthorized }
        format.json { render json: { error: 'Invalid email or password' }, status: :unauthorized }
      end
    end
  end

  def after_sign_in_path_for(resource)
    if resource.respond_to?(:disclaimer_accepted?) && resource.disclaimer_accepted?
      disclaimer_path # Redirect to /disclaimer after sign-in if disclaimer is accepted
    else
      legal_disclaimer_path
    end
  end

  def after_sign_out_path_for(resource)
    legal_disclaimer_path
  end
end