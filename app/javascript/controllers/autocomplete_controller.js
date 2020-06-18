import { Controller } from "stimulus";

class AutocompleteController extends Controller {
  static classes = ["hidden"];
  static targets = ["input", "inputContainer", "user"];

  filterUsers(event) {
    this.inputContainerTarget.classList.remove(this.hiddenClass);

    this.userTargets.filter(user => {
      const name = user.textContent.toLowerCase();
      const inputValue = event.target.value.toLowerCase();

      user.classList.toggle(this.hiddenClass, !name.includes(inputValue));
    });
  }

  setInputValue(event) {
    this.inputTarget.value = event.target.textContent.trim();
  }

  closeContainer(event) {
    if (event.target !== this.inputTarget) {
      this.inputContainerTarget.classList.add(this.hiddenClass);
    }
  }
}

export default AutocompleteController;
