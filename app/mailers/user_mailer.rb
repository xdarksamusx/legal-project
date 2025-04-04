class UserMailer < ApplicationMailer
  default from: "notifications@example.com"

  def welcome_email
    @user = params[:user]
    @url = Rails.application.routes.url_helpers.new_user_session_url(host: 'localhost', port: 3000)
    mail(to: @user.email, subject: "Welcome to My Awesome Site")
  end


end
