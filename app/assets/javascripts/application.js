// A default Rails installation would have a manifest file here that would
// include references to all JavaScript files used in the project. For those
// familiar with the default setup, please read the difference below carefully.
//
// Instead of an application.js manifest file, this project uses the
// requirejs-rails gem (https://github.com/jwhitley/requirejs-rails) to enable
// modular JavaScript development and dependency management in the project.
// This allows JavaScript to be encapsulated in modules and allows control over
// where and when the modules execute. Each module follows the
// Asynchronous Module Definition (AMD) pattern for JavaScript modules and uses
// the RequireJS library as the module loader.
//
// At its very basic, each JavaScript file defines a module that at least
// contains the following structure (with either a require or define command):
//
// require(
// function () {
//   'use strict';
//   // Module content goes here.
// });
//
// The 'require' command defines what JavaScript is required in this file,
// whereas if in place of 'require' it said 'define', that would mean a
// module was being defined that could be set as a dependency elsewhere.
// The main difference is a defined module will have a return value in its
// function. Defined modules can be found in (e.g.) app/assets/javascripts/app.
//
// The optional first argument of the 'require'/'define' method is an array
// of JavaScript modules that this module depends on for its execution.
// For instance, if before this module, ModuleA, runs its own logic,
// we need another two modules to be loaded (ModuleB and ModuleC).
// We need to tell ModuleA it depends on other modules. To do this
// we would include the path to the other modules in what's known as the
// 'dependency array' of ModuleA.
//
// The array is a list of strings with the path of the modules relative
// to the Rails app/assets/javascripts/ directory, each with the .js file
// extension removed. So the example pseudocode below would include the
// files moduleB.js and moduleC.js.
//
// After the array is an anonymous function enclosing the module content.
// The external modules can be given any argument names in this function,
// which can be used to access their methods (such as an init method).
//
// // ModuleA
// require([
//   'path/to/moduleB',
//   'path/to/moduleC'
// ],
// function (moduleB, moduleC) {
//   'use strict';
//
//   // Depending on how the module was built, it likely will include an init
//   // method to control when and where it's initialized.
//   moduleB.init();
//   moduleC.init();
// });
//
// So instead of using, e.g. '//= require jquery', in this file, add the path
// to the JavaScript module that is needed as a dependency in the dependency
// array.
//
// Configuration for RequireJS, such as including 3rd party vendor scripts that
// aren't formatted as AMD modules, can be found in config/requirejs.yml.
//
// THIS FILE SPECIFIES JAVASCRIPT MODULES THAT ARE INCLUDED ON ALL PAGES OF THE
// SITE. TO INCLUDE A MODULE ON ONLY SPECIFIC PAGES (VIEWS) ADD IT TO THE
// DEPENDENCY ARRAY OF A PARTICULAR VIEW MODULE; ALL OF WHICH ARE FOUND IN
// app/assets/javascripts/routes/.
//
require([
  'util/translation/google-translate',
  'domReady!'
],
function (googleTranslate) {
  'use strict';

  // The google-translate script handles loading of the
  // Google Website Translator Gadget at the bottom of the page's body.
  // The layout settings passed in as an argument to the initialization
  // method can be set to:
  // InlineLayout.VERTICAL, InlineLayout.HORIZONTAL,
  // which correspond to the 'inline' display modes available through Google.
  // The 'tabbed' and 'auto' display modes are not supported.
  // The 'inline' InlineLayout.SIMPLE layout is also not supported.
  googleTranslate.init(googleTranslate.InlineLayout.VERTICAL);
});
