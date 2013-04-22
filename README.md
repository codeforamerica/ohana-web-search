#Human Services Finder

A brand new project underway by Code for America's 2013 San Mateo County fellowship team. The goal is to build an interface that makes it easy to find available services in San Mateo County, and to provide as much pertinent information as possible, such as travel directions, hours of operation, other services residents in need  might be eligible for, etc.

This repo is in the early stages of development. There is not much to see yet. We are still trying to figure out the best way to organize the data that we got from the Peninsula Library System. 

Some of the data we're using is available in JSON format in the [data folder](https://github.com/codeforamerica/human_services_finder/tree/master/data).

Some front-end work is being done independently of the Rails app on the [html5boilerplate branch](https://github.com/codeforamerica/human_services_finder/tree/html5boilerplate/public/boilerplate).


## Installation
[Set up a dev environment with Homebrew, Git, Ruby, and Rails](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)

Install mongodb:

    brew update
    brew install mongodb

Follow the Homebrew instructions for configuring MongoDB

Launch mongodb in a separate Terminal tab or window:

    mongod

Install the app on your local machine:

    git clone git://github.com/codeforamerica/human_services_finder.git
    cd human_services_finder
    bundle

To load the [libraries data](https://github.com/codeforamerica/human_services_finder/blob/master/data/libraries_data.json) in your local db:

    rake load_data

To run locally:

    unicorn

Then visit [http://localhost:8080](http://localhost:8080)

## Development Details

* Ruby version 2.0.0
* Rails version 3.2.13
* MongoDB with the Mongoid ORM
* Template Engine: ERB
* Testing Framework: RSpec and Factory Girl and Cucumber
* Front-end Framework: Twitter Bootstrap (Sass)
* Form Builder: SimpleForm
* Authentication: OmniAuth
* Authorization: CanCan
* Email Sending: Mandrill

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/human_services_finder/blob/master/LICENSE.md) for details.