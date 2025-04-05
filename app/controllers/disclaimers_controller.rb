class DisclaimersController < ApplicationController


  def index
    @user = current_user
    @disclaimers = @user.disclaimers
  end

  def show 
  end

  def create 

    @user =  current_user
    @disclaimer = Disclaimer.new
    @disclaimer.user = @user

    topic = params[:topic]
    tone = params[:tone]

    client = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])

    prompt = "Write a short legal disclaimer for: #{topic}"
    prompt += "Use a #{tone.downcase} tone." if tone.present?
    

    response = client.chat(
      parameters: {
        model: "gpt-4o-mini",
        messages: [
          {
            role: "user", content:prompt
          }
        ],
        temperature: 0.7
      }



    )

    puts response

 

    @disclaimer.statement = (response.dig("choices", 0, "message", "content") || "Something went wrong. Please try again.").truncate(810, separator: '')


    if @disclaimer.save 
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("disclaimer-section", partial:"disclaimers/disclaimer", locals: {disclaimer: @disclaimer})
        end
        format.html{render :new}
      end
    else
      render :new
    end
    



    
     


  end

  def new 
    puts "New action called!"
    @disclaimer ||= nil 
  end

  def destroy 
  end

  def update 
  end

  private

  def disclaimer_params
    params.permit(:statement)
  end








end
