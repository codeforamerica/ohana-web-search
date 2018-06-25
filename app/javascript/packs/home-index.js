// Manages home page script initialization.
import geo from 'app/util/geolocation/geolocate-action';

// Initialize the geolocation button on the homepage.
// locateAction is the callback function for when the
// address is found.
function locateAction(address) {
  document.getElementById('location').value = address;
  document.getElementById('form-search').submit();
}
// Parameters are: button ID, and callback function (see above).
geo.init('button-geolocate', locateAction);
