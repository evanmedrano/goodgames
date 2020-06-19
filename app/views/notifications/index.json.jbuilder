json.array! @notifications do |notification|
  json.id notification.id
  json.actor notification.actor.first_name
  json.action notification.action
  json.notifiable do
    json.type "a #{notification.notifiable_type.underscore.humanize.downcase}"
  end
  json.actorUrl user_library_path(notification.actor)
  json.notifiableUrl user_inbox_index_path(
    notification.recipient,
    anchor: dom_id(notification.notifiable),
  )
end
