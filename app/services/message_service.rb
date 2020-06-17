class MessageService
  def initialize(params = {})
    @body = params[:body]
    @recipient_id = params[:recipient_id]
    @sender_id = params[:sender_id]
    @subject = params[:subject]
  end

  def save
    if initialized_message.valid?
      initialized_message.save
      enqueue_user_message_job
      true
    else
      false
    end
  end

  private

  attr_reader :body, :recipient_id, :sender_id, :subject

  def initialized_message
    Message.new(
      body: body, recipient_id: recipient_id, sender_id: sender_id, subject: subject
    )
  end

  def enqueue_user_message_job
    UserMessageJob.perform_later(
      recipient_id: recipient_id, sender_id: sender_id
    )
  end
end
