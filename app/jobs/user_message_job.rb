class UserMessageJob < ApplicationJob
  queue_as :mailers

  def perform(recipient_id:, sender_id:)
    recipient = User.find_by(id: recipient_id)
    sender = User.find_by(id: sender_id)

    UserMailer.send_user_message(recipient: recipient, sender: sender).
      deliver_later
  end
end
