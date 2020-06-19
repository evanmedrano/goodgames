class NotificationService
  include ActiveModel::Model

  validates :action, presence: true
  validates :actor_id, presence: true
  validates :notifiable, presence: true
  validates :recipient_id, presence: true

  def initialize(params = {})
    @action = params[:action]
    @actor_id = params[:actor_id]
    @notifiable = params[:notifiable]
    @recipient_id = params[:recipient_id]
  end

  def save
    if valid?
      initialized_notification.save
      true
    else
      false
    end
  end

  private

  attr_reader :action, :actor_id, :notifiable, :recipient_id

  def initialized_notification
    Notification.new(
      action: action,
      actor_id: actor_id,
      notifiable: notifiable,
      recipient_id: recipient_id,
    )
  end
end
