class Users::SessionsController < Devise::SessionsController

 
  def create
    Rails.logger.debug "Resetting session before login"
    reset_session # Reset the session to avoid token mismatch
    super
  end
end