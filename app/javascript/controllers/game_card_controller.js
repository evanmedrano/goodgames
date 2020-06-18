import { Controller } from 'stimulus';

class GameCardController extends Controller {
  static targets = ["gameVideo"];

  playVideo() {
    this.gameVideoTarget.play();
  }

  pauseVideo() {
    this.gameVideoTarget.pause();
  }
}

export default GameCardController;
