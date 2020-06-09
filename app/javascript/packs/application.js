// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import "bootstrap"
import "../stylesheets/application"

document.addEventListener("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover();
})


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

window.onload = function () { //executes code after DOM loads
  //--- select all <video> on the page
  const games = document.getElementsByClassName('card')
  //const posters = document.getElementsByClassName('card__poster')
  // Loop over the selected elements and add event listeners
  for (let i = 0; i < games.length; i++) {
    // var sourceMP4 = document.createElement("source");
    // sourceMP4.type = "video/mp4";
    // sourceMP4.src = games[i].src;
    // games[i].appendChild(sourceMP4);
    
    
    games[i].addEventListener('mouseover', function (e) {
      games[i].querySelector('video').play()
    })
    games[i].addEventListener('mouseout', function (e) {
      games[i].querySelector('video').pause()
      //var setPoster = e.target.poster
      // e.target.src = ""
      // e.target.removeAttribute("src")
      // var poster = games[i].attr("poster")
      // e.target.poster = ""
      // e.target.poster = setPoster
    })
  }
}
import "controllers"
