class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:csrf_token, :check]
   protect_from_forgery with: :exception, unless: -> { request.format.json? }

   


  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  

  protected 

  def set_csrf_cookie
    cookies['CSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end




  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
end
