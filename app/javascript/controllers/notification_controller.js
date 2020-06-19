import { Controller } from "stimulus";

class NotificationController extends Controller {
  static targets = [
    "notifications",
    "notificationItems",
    "notificationLink",
    "unreadNotificationCount"
  ];

  connect() {
    if (this.notificationsTarget) {
      this.setup();
    }
  }

  setup() {
    this.notificationLinkTarget.addEventListener("click", this.handleClick);
    fetch("/notifications.json")
      .then(response => response.json())
      .then(json => this.handleSuccess(json));
  }

  handleClick() {
    fetch("/notifications/mark_as_read", { method: "post" }).then(response =>
      response.json()
    );

    const notificationCount = document.querySelector("small");
    notificationCount.innerHTML = 0;
  }

  handleSuccess(data) {
    if (data.length > 0) {
      const items = this.renderNotifications(data);

      this.unreadNotificationCountTarget.innerHTML = items.length;
      this.renderNotificationsDropdown(items);
    } else {
      this.unreadNotificationCountTarget.innerHTML = 0;
    }
  }

  renderNotificationsDropdown(items) {
    const dropdownDivider = this.renderDropdownDivider();
    const allNotificationsLink = this.renderNotificationsLink();

    this.notificationItemsTarget.innerHTML = items;
    this.notificationItemsTarget.appendChild(dropdownDivider);
    this.notificationItemsTarget.appendChild(allNotificationsLink);
  }

  renderNotifications(data) {
    return data.map(notification => {
      return `<li class="dropdown-item">
           <a href=${notification.actorUrl} class="link--blue">
             ${notification.actor}
           </a>
           <span class="text--neutral">${notification.action}</span>
           <a href=${notification.notifiableUrl} class="link--blue">
             ${notification.notifiable.type}
           </a>
        </li>`;
    });
  }

  renderNotificationsLink() {
    const allNotificationsLink = document.createElement("a");
    allNotificationsLink.textContent = "All notifications";
    allNotificationsLink.classList.add("dropdown-item");
    allNotificationsLink.href = "/notifications";

    return allNotificationsLink;
  }

  renderDropdownDivider() {
    const dropdownDivider = document.createElement("div");
    dropdownDivider.classList.add("dropdown-divider");

    return dropdownDivider;
  }
}

export default NotificationController;
