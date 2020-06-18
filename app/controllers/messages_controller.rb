class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def new
    @message = Message.new
  end

  def create
    @message = MessageService.new(message_params)

    if @message.save
      redirect_to user_library_url(@user), notice: "Message sent!"
    else
      flash.now[:alert] = "There was an error saving the message."
      render :new
    end
  end

  private

  def set_user
    @user = current_user
  end

  def message_params
    params.require(:message).permit(:subject, :body, :recipient_id, :sender_id)
  end
end
