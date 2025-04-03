class DisclaimersController < ApplicationController


  def index
  end

  def show 
  end

  def create 
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

    puts response.inspect


    @disclaimer = response.dig("choices", 0, "message", "content") || "Something went wrong. Please try again."

    @disclaimer = @disclaimer.truncate(810, sepatator: '')

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("disclaimer-section", partial:"disclaimers/disclaimer", locals: {disclaimer: @disclaimer})
      end
      format.html{render :new}
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







end
