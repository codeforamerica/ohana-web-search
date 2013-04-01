#Human Services Finder

An app built by Code for America's 2013 San Mateo County fellowship team. It allows residents to easily find organizations that provide human services in San Mateo County. It also makes it easy for nonprofits and other community-based organizations to refer their clients to those services.

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

## Contributing

If you make improvements to this application, please share with others.

* Fork the project on GitHub.
* Make your feature addition or bug fix.
* Commit with Git.
* Send the author a pull request.

If you add functionality to this application, create an alternative implementation, or build an application that is similar, please contact me and I'll add a note to the README so that others can find your work.

## License