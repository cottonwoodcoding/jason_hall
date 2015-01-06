class ContactController < ApplicationController
  def index
  end

  def send_feedback
    begin
      ContactMailer.send_feedback(params[:email], params[:name], params[:message]).deliver
      flash[:notice] = "Feedback Sent Successfully"
    rescue => e
      flash[:alert] = 'There was an error sending your feedback please try again.'
    end
    redirect_to action: :index
  end
end
