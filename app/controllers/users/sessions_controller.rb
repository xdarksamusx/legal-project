class Users::SessionsController < Devise::SessionsController
  def new
    if user_signed_in?
      redirect_to disclaimer_path and return
    end
    super
  end

  def after_sign_in_path_for(resource)
    disclaimer_path
  end
end