json.array! @notifications do |notification|
  json.actor notification.actor.name
  json.action notification.action
  json.notifiable do
    json.type "a #{notification.notifiable_type.underscore.humanize.downcase}"
  end
  json.actorUrl user_library_path(notification.actor)
  json.notifiableUrl notification.notifiable.notification_link(
    notification.recipient,
    notification.notifiable
  )
end
