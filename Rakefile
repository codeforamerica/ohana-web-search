#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

HumanServicesFinder::Application.load_tasks

# Enables running of teaspoon gem by default when rake is run.
# Teaspoon is a JS testing gem using JasmineJS (https://github.com/pivotal/jasmine).
#task :tests => [:spec, :teaspoon]
#task :default => [:tests]