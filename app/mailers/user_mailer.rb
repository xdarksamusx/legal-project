class UserMailer < ApplicationMailer
  default from: "notifications@example.com"

  def welcome_email
    @user = params[:user]
    @url = Rails.application.routes.url_helpers.new_user_session_url(host: 'localhost', port: 3000)
    mail(to: @user.email, subject: "Welcome to My Awesome Site")
  end

  def disclaimer_copy 

    @url_helpers = Rails.application.routes.url_helpers

    @user = params[:user]
    @disclaimer = params[:disclaimer]

    @txt_url = Rails.application.routes.url_helpers.download_txt_disclaimer_url(@disclaimer, host: 'localhost', port: 3000)
    @pdf_url = Rails.application.routes.url_helpers.download_pdf_disclaimer_url(@disclaimer, host: 'localhost', port: 3000)  
    mail(to: @user.email, subject: "Disclaimer Generated")

 
    




  end



end
