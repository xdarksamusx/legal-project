
require 'prawn'

class DisclaimersController < ApplicationController
  before_action :authenticate_user!, except: [:legal, :accept_legal] # Skip for static disclaimer actions
  before_action :set_disclaimer, only: [:show, :edit, :update, :destroy, :download_pdf, :download_txt]
  skip_before_action :verify_authenticity_token, only: [:create]

  # Static disclaimer for acceptance (before sign-in)
  def legal
    respond_to do |format|
      format.html { render :legal }
      format.json { render json: { message: 'Static disclaimer page' }, status: :ok }
    end
  end

  def accept_legal
    if current_user
      current_user.update(disclaimer_accepted: true)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'Disclaimer accepted.' }
        format.json { render json: { message: 'Disclaimer accepted' }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: 'Please sign in to accept the disclaimer.' }
        format.json { render json: { error: 'Please sign in to accept the disclaimer' }, status: :unauthorized }
      end
    end
  end

  # Existing actions for generating disclaimers
  def index
    @user = current_user
    @disclaimers = @user.disclaimers

    respond_to do |format|
      format.html
      format.json { render json: @disclaimers }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @disclaimer }
    end
  end

  def create
    @user = current_user
    @disclaimer = Disclaimer.new(disclaimer_params)
    @disclaimer.user = @user

    topic = params[:topic]
    tone = params[:tone]

    begin
      client = OpenAI::Client.new(access_token: ENV["OPENAI_ACCESS_TOKEN"])
      prompt = "Write a short legal disclaimer for: #{topic}"
      prompt += " Use a #{tone.downcase} tone." if tone.present?

      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          messages: [
            { role: "user", content: prompt }
          ],
          temperature: 0.7
        }
      )

      @disclaimer.statement = (response.dig("choices", 0, "message", "content") || "Something went wrong. Please try again.").truncate(810, separator: '')
    rescue StandardError => e
      @disclaimer.statement = "Error generating disclaimer: #{e.message}"
    end

    if @disclaimer.save
      UserMailer.with(user: @user, disclaimer: @disclaimer).disclaimer_copy.deliver_now

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "disclaimer-section",
            partial: "disclaimers/disclaimer",
            locals: { disclaimer: @disclaimer }
          )
        end
        format.html { redirect_to disclaimers_path, notice: 'Disclaimer created successfully.' }
        format.json { render json: { statement: @disclaimer.statement }, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { error: @disclaimer.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def new
    puts "New action called!"
    @disclaimer = Disclaimer.new
    respond_to do |format|
      format.html { render :new }
      format.json { render json: { disclaimer: @disclaimer }, status: :ok }
    end
  end

  def destroy
    @disclaimer.destroy
    respond_to do |format|
      format.html { redirect_to disclaimers_path, notice: "Disclaimer deleted." }
      format.json { render json: { message: "Disclaimer deleted." }, status: :ok }
    end
  end

  def update
    if @disclaimer.update(disclaimer_params)
      respond_to do |format|
        format.html { redirect_to disclaimers_path, notice: "Disclaimer updated successfully." }
        format.json { render json: { disclaimer: @disclaimer }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { error: @disclaimer.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.json { render json: { disclaimer: @disclaimer } }
    end
  end

  def download_txt
    timestamp = Time.now.strftime("%Y-%m-%d_%H-%M")
    filename = "disclaimer_#{@disclaimer.id}_#{timestamp}.txt"

    send_data @disclaimer.statement,
              filename: filename,
              type: 'text/plain',
              disposition: 'inline'
  end

  def download_pdf
    timestamp = Time.now.strftime("%Y-%m-%d_%H-%M")
    filename = "disclaimer_#{@disclaimer.id}_#{timestamp}.pdf"

    pdf = Prawn::Document.new
    pdf.text "Your Disclaimer", size: 18, style: :bold
    pdf.move_down 20
    pdf.text @disclaimer.statement, size: 12, leading: 4

    send_data pdf.render,
              filename: filename,
              type: 'application/pdf',
              disposition: 'inline'
  end

  def accept_legal
    if current_user
      begin
        # Check if the attribute exists before updating
        if current_user.respond_to?(:disclaimer_accepted=)
          current_user.update(disclaimer_accepted: true)
          respond_to do |format|
            format.html { redirect_to root_path, notice: 'Disclaimer accepted.' }
            format.json { render json: { message: 'Disclaimer accepted' }, status: :ok }
          end
        else
          respond_to do |format|
            format.html { redirect_to root_path, alert: 'Error: Disclaimer acceptance not available.' }
            format.json { render json: { error: 'Disclaimer acceptance not available' }, status: :unprocessable_entity }
          end
        end
      rescue ActiveModel::UnknownAttributeError => e
        respond_to do |format|
          format.html { redirect_to root_path, alert: 'Error: Disclaimer acceptance not available.' }
          format.json { render json: { error: e.message }, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_user_session_path, alert: 'Please sign in to accept the disclaimer.' }
        format.json { render json: { error: 'Please sign in to accept the disclaimer' }, status: :unauthorized }
      end
    end
  end

  private

  def set_disclaimer
    @disclaimer = current_user.disclaimers.find(params[:id])
  end

  def disclaimer_params
    params.require(:disclaimer).permit(:statement, :topic, :tone).merge(statement: '')
  end
end