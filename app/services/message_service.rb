class MessageService
  include ActiveModel::Model

  validates :body, presence: true
  validates :recipient_id, presence: true
  validates :subject, presence: true

  def initialize(params = {})
    @body = params[:body]
    @recipient_id = convert_recipient_id?(params[:recipient_id])
    @sender_id = params[:sender_id]
    @subject = params[:subject]
  end

  def save
    if valid?
      enqueue_user_message_job
      create_notification
      true
    else
      false
    end
  end

  private

  attr_reader :body, :recipient_id, :sender_id, :subject

  def initialized_message
    Message.new(
      body: body,
      recipient_id: recipient_id,
      sender_id: sender_id,
      subject: subject
    )
  end

  def enqueue_user_message_job
    UserMessageJob.perform_later(
      recipient_id: recipient_id, sender_id: sender_id
    )
  end

  def create_notification
    NotificationService.new(notification_params).save
  end

  def convert_recipient_id?(recipient_id)
    if recipient_id_is_an_integer?(recipient_id)
      recipient_id
    else
      first_name = recipient_id.split[0]
      User.find_by(first_name: first_name).id
    end
  end

  def recipient_id_is_an_integer?(recipient_id)
    recipient_id.is_a?(Integer) || recipient_id.match?(/\d/)
  end

  def notification_params
    {
      action: "sent",
      actor_id: sender_id,
      notifiable: initialized_message,
      recipient_id: recipient_id,
    }
  end
end
