// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require lib/require/require.min

require.config({
	baseUrl: "/assets/module",

	// setup alias to js libraries
	paths: {
  	'domReady':'../lib/require/domReady',
  	'jquery':'../lib/jquery.min',
  	'enquire':'../lib/enquire.min'
	},

	// see example here for mapbox shim: https://gist.github.com/rjmackay/5762195
	shim: {
    'http://api.tiles.mapbox.com/mapbox.js/v1.0.2/mapbox.js' : {
        exports: 'L'
    }
	}
});

