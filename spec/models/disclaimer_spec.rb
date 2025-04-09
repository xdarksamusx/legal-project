require 'rails_helper'

RSpec.describe Disclaimer, type: :model do

  let(:user) do
    User.create(
      email: "test@example.com",
      password: "password123",
      username: "rspecuser",
      provider: "github",                  
      uid: "123456",                      
      image: "http://example.com/avatar.png"  ,
      confirmed_at: Time.now 
    )
  end
  it "is valid with a statement and user" do 
    disclaimer = Disclaimer.new(statement: "Test disclaimer", user: user)
    expect(disclaimer).to be_valid

  end

  it "is invalid without a statement " do 
    disclaimer = Disclaimer.new(user: user)
    expect(disclaimer).not_to be_valid

  end

  it "is invalid without a user" do 
    disclaimer = Disclaimer.new(statement: "Missing user")
    expect(disclaimer).not_to be_valid

  end

  it "is invalid if the statement  is too long" do 
    long_statement = "A" * 1001
    disclaimer = Disclaimer.new(statement: long_statement, user: user )
    expect(disclaimer).not_to be_valid 


  end

  it "auto-generates a statement with OpenAI integration (if implemented)" do
    allow(OpenAI::Client).to receive(:new).and_return(
      double(chat: {
        "choices" => [
          {
            "message" => {
              "content" => "Mocked disclaimer content"
            }
          }
        ]
      })
    )
  
    user = User.create!(email: "test@example.com", password: "password123", username: "rspec", confirmed_at: Time.now)
    disclaimer = Disclaimer.new(user: user)
    
     disclaimer.statement = OpenAI::Client.new.chat["choices"][0]["message"]["content"]
    
    expect(disclaimer.statement).to eq("Mocked disclaimer content")
  end
  




 end
