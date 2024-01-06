import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "jquery"
import "popper.js"
import "bootstrap"

import "../stylesheets/application" 
import './chart.js.erb'; // Import the ERB file

document.addEventListener('turbolinks:load', () => {
  Rails.start()
  Turbolinks.start()
  ActiveStorage.start()
});