class Users::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :require_permission!, only: [:index, :show]
  before_action :set_message, only: [:show, :delete]

  def index
  end

  def show
  end

  def new
    @message = Message.new
  end

  def create
    message = MessageService.new(message_params)

    if message.save
      redirect_to user_library_url(@user), notice: "Message sent!"
    else
      flash.now[:alert] = "There was an error saving the message."
      render :new
    end
  end

  def destroy
    message = Message.find_by(id: params[:id])

    if message.destroy
      redirect_to user_messages_url(@user), notice: "Message deleted."
    else
      redirect_to user_messages_url(@user), alert: "Unable to delete message."
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def set_message
    @message = Message.find_by(id: params[:id])
  end

  def require_permission!
    if current_user != @user
      redirect_to root_url, alert: "You do not have access to this page."
    end
  end

  def message_params
    params.require(:message).permit(:subject, :body, :recipient_id, :sender_id)
  end
end
