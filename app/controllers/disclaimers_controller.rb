
require 'prawn'


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
      UserMailer.with(user: @user, disclaimer: @disclaimer).disclaimer_copy.deliver_now

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
    @disclaimer = current_user.disclaimers.find(params[:id])
    @disclaimer.destroy 
    redirect_to disclaimers_path, notice: "Disclaimers deleted "
   
  end

  def update 
    @disclaimer = current_user.disclaimers.find(params[:id])
    if @disclaimer.update(disclaimer_params)
      redirect_to disclaimers_path, notice: "Disclaimer updated successfully"
    else
      
      render :edit, alert: "Update failed"
    end

  end

  def edit 
    @disclaimer = current_user.disclaimers.find(params[:id])
  end


 

  

  def disclaimer_params
    params.require(:disclaimer).permit(:statement)
  end


  def download_txt 
    disclaimer = current_user.disclaimers.find(params[:id])
    send_data disclaimer.statement,
    filename: "disclaimer_#{disclaimer.id}.txt",
    type: 'text/plain',
    disposition: 'inline'

  end

  def download_pdf
    disclaimer = current_user.disclaimers.find(params[:id])
    pdf = Prawn::Document.new 
    pdf.text "Your Disclaiemr", sixe: 18, style: :bold 
    pdf.move_down 10 
    pdf.text disclaimer.statement 
    send_data pdf.render,
    filename: "disclaimer_#{disclaimer.id}.pdf",
    type: 'application/pdf',
    disposition: 'inline'

 
  end

  private








end
