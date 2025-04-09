class User < ApplicationRecord


  def self.from_omniauth(auth)
    # Step 1: Try to find user by provider + uid
    user = find_by(provider: auth["provider"], uid: auth["uid"])
  
    # Step 2: Fallback to finding by email
    if user.nil? && auth["info"]["email"].present?
      user = find_by(email: auth["info"]["email"])
    end
  
    # Step 3: Initialize new user if still not found
    user ||= new
  
    # Step 4: Assign attributes safely
    user.email = auth["info"]["email"] if user.email.blank?
    user.password ||= Devise.friendly_token[0, 20]
    user.provider ||= auth["provider"]
    user.uid ||= auth["uid"]
    user.confirmed_at ||= Time.now
  
    user.save!
    user
  end
  
  
  


  has_many :disclaimers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable , :omniauthable, omniauth_providers: [:github, :spotify]

  



end
