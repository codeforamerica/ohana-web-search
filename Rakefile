#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

HumanServicesFinder::Application.load_tasks

# enables default running of teaspoon
#task :tests => [:spec, :teaspoon]
#task :default => [:tests]

require "jshintrb/jshinttask"
Jshintrb::JshintTask.new :jshint do |t|
  t.pattern = "app/assets/javascripts/**/*.js"
  #t.options = :defaults
  # Custom options are below, uncomment the line
  # above for the default set of options.
  t.options = {
    :bitwise => true,
    :curly => false,
    :eqeqeq => true,
    :forin => true,
    :immed => true,
    :indent => 2,
    :latedef => true,
    :newcap => true,
    :noarg => true,
    :noempty => true,
    :nonew => true,
    :plusplus => false,
    :regexp => true,
    :undef => true,
    :strict => true,
    :trailing => true,
    :sub => true,
    :browser => true,
    :devel => true,
    :expr => true,
    :predef => {
      "requirejs" => false,
      "require" => false,
      "define" => false,
      "Modernizr" => false,
      "selectorSupported" => false,
      "google" => false
    }
  }
end