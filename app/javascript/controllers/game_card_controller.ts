import { Controller } from 'stimulus';

class GameCardController extends Controller {
  static targets = ["gameVideo"];

  gameVideoTarget: HTMLVideoElement;

  playVideo(): void {
    this.gameVideoTarget.play();
  }

  pauseVideo(): void {
    this.gameVideoTarget.pause();
  }
}

export default GameCardController;
