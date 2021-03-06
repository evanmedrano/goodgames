class Users::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_recipient, only: [:new, :create]
  before_action :set_message, only: [:delete]

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

  def destroy
    message = Message.find_by(id: params[:id])

    if message.destroy
      redirect_to user_inbox_index_url(current_user), notice: "Message deleted."
    else
      flash[:alert] = "Unable to delete the message."
      redirect_to user_inbox_index_url(current_user)
    end
  end

  private

  def set_user
    @user = current_user
  end

  def set_recipient
    @user = User.find_by(id: params[:user_id])
  end

  def set_message
    @message = Message.find_by(id: params[:id])
  end

  def message_params
    params.require(:message).permit(:subject, :body, :recipient_id, :sender_id)
  end
end
