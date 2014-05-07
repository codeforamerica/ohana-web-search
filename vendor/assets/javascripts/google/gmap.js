define('gmaps', ['async!https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false!callback'],
function(){
	return window.google.maps;
});