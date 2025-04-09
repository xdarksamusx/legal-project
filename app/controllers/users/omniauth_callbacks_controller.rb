# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def spotify
    puts request.env["omniauth.auth"].inspect


    @user = User.from_omniauth(request.env["omniauth.auth"])
  
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Spotify") if is_navigational_format?
    else
 
      session["devise_github_data"] = request.env["omniauth.auth"].slice("provider", "uid", "info")
      redirect_to new_user_registration_url
    end
  end
  


  def github 
    puts request.env["omniauth.auth"].inspect

    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else
      session["devise_github_data"] = request.env["omniauth.auth"].slice("provider", "uid", "info")
      redirect_to new_user_registration_url
    end  # 
  end      
  





end
