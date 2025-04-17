class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  def set_csrf_cookie
    cookies["CSRF-TOKEN"] = form_authenticity_token
  end

  def csrf_token
    set_csrf_cookie
    render json: { csrf_token: form_authenticity_token }
  end
end