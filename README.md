#Ohana Web Search

[![Build Status](https://travis-ci.org/codeforamerica/ohana-web-search.png?branch=master)](https://travis-ci.org/codeforamerica/ohana-web-search) [![Coverage Status](https://coveralls.io/repos/codeforamerica/ohana-web-search/badge.png?branch=master)](https://coveralls.io/r/codeforamerica/ohana-web-search) [![Dependency Status](https://gemnasium.com/codeforamerica/ohana-web-search.png)](https://gemnasium.com/codeforamerica/ohana-web-search)
[![Stories in Ready](https://badge.waffle.io/codeforamerica/ohana-web-search.png?label=ready)](https://waffle.io/codeforamerica/ohana-web-search)

Ohana Web Search is one of two Rails apps that come out of the box with the [Ohana API](https://github.com/codeforamerica/ohana-api) platform. The other app is an [admin interface](https://github.com/codeforamerica/ohana-api-admin) that allows people to update the data. Both apps also serve as examples of what can be built on top of the social services data that the Ohana API exposes.

This project was developed by [Code for America's 2013 San Mateo County](http://codeforamerica.org/2013-partners/san-mateo-county/) fellowship team. Thanks to a [grant from the Knight Foundation](http://www.knightfoundation.org/grants/201447979/), [@monfresh](https://github.com/monfresh), [@spara](https://github.com/spara), and [@anselmbradford](https://github.com/anselmbradford) will continue to push code in 2014.

Ohana Web Search aims to make it easy to find available services in a community, and to provide as much pertinent information as possible, such as travel directions, hours of operation, other services residents in need might be eligible for, etc.
You can see a live example for services in San Mateo County here: [http://smc-connect.org](http://smc-connect.org)

We gladly welcome contributions. Below you will find instructions for installing the project and contributing.

## Stack Overview

* Ruby version 2.1.1
* Rails version 3.2.17
* Template Engines: ERB and HAML
* Testing Frameworks: RSpec, Capybara and PhantomJS (via Poltergeist gem), JasmineJS installed but not currently used (via Teaspoon gem)

## Deploying to Heroku
See the [Wiki](https://github.com/codeforamerica/ohana-web-search/wiki/How-to-deploy-Ohana-Web-Search-to-your-Heroku-account).

## Installation
Please note that the instructions below have only been tested on OS X. If you are running another operating system and run into any issues, feel free to update this README, or open an issue if you are unable to resolve installation issues.

###Prerequisites

#### Git, Ruby 2.1+, Rails 3.2.17+ (+ Homebrew on OS X)
**OS X**: [Set up a dev environment on OS X with Homebrew, Git, RVM, Ruby, and Rails](http://www.moncefbelyamani.com/how-to-install-xcode-homebrew-git-rvm-ruby-on-mac/)

**Windows**: Try [RailsInstaller](http://railsinstaller.org), along with some of these [tutorials](https://www.google.com/search?q=install+rails+on+windows) if you get stuck.

**Linux**:

* [RVM](http://rvm.io) is great, and this project uses it, but in any case, try to use the same ruby version as listed in the .ruby-version file. If you install it, it'll take care of making sure you have the right ruby, and let you focus on contributing to the app.
* You need a Javascript runtime. We recommend Node.JS (if you have a good reason not to use it, [there are other options](https://github.com/sstephenson/execjs)). On Ubuntu, it's as simple as <code>sudo apt-get install nodejs</code>. On others, [check the official instructions](https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager).

#### PhantomJS
[Installation instructions](https://github.com/jonleighton/poltergeist#installing-phantomjs) for Mac, Linux, and Windows

### Clone the app on your local machine:

    git clone https://github.com/codeforamerica/ohana-web-search.git
    cd ohana-web-search

### Install the dependencies:

    bundle

### Set up the environment variables
Inside the `config` folder, you will find a file named `application.example.yml`. Rename it to `application.yml` and double check that it has been added to your `.gitignore` file (it should be by default).

By default, the app is configured to point to the demo API at `http://ohanapi.herokuapp.com/api`. To point to your own instance of Ohana API, change the value of `OHANA_API_ENDPOINT` in your `application.yml`.

### Run the app
Start the app locally on port 4000 using Unicorn:

    unicorn -p 4000

Ohana SMC should now be running at [http://lvh.me:4000](http://lvh.me:4000)

The `-p` option allows you to specify which port you want to run the server on. This is useful when running other servers at the same time. For example, if you're also running the Ohana API locally (which uses port 8080 by default), you wouldn't be able to run Ohana Web Search with the simple `unicorn` command, because it would also default to port 8080. By specifying a different port number, you can run both servers at the same time.

Please make sure you are using `lvh.me` instead of `localhost` to be able to test the translation feature. Read more about [lvh.me](http://matthewhutchinson.net/2011/1/10/configuring-subdomains-in-development-with-lvhme).

### Test the app
To test locally, you can run tests with this simple command:

    rspec

To configure rspec output formatting (for example, to provide command line output in color), use the command from the command line `pico ./.rspec` while in the project root directory (or `pico ~/.rspec` to provide rspec configuration globally for all projects on your machine). Settings such as color highlighting and the output style can be set with:

    --color
    --format documentation

Options for the format configuration are `progress` (default - shows a series of dots), `documentation`, `html`, or `textmate`. [More information can be found on the rspec website](https://www.relishapp.com/rspec/rspec-core/v/2-0/docs/configuration/read-command-line-configuration-options-from-files).

For faster tests:

    gem install zeus
    zeus start #in a separate Terminal window or tab
    zeus rspec spec

To see the actual tests, browse through the [spec](https://github.com/codeforamerica/ohana-web-search/tree/master/spec) directory.

## Contributing
In the spirit of open source software, **everyone** is encouraged to help improve this project.

Here are some ways *you* can contribute:

* by using alpha, beta, and prerelease versions
* by reporting bugs
* by suggesting new features
* by suggesting labels for our issues
* by writing or editing documentation
* by writing specifications
* by writing code (**no patch is too small**: fix typos, add comments, clean up
  inconsistent whitespace)
* by refactoring code
* by closing [issues](https://github.com/codeforamerica/ohana-web-search/issues)
* by reviewing patches
* [financially](https://secure.codeforamerica.org/page/contribute)

## Submitting an Issue
We use the [GitHub issue tracker](https://github.com/codeforamerica/ohana-web-search/issues) to track bugs and features. Before submitting a bug report or feature request, check to make sure it hasn't already been submitted. When submitting a bug report, please include a [Gist](https://gist.github.com/) that includes a stack trace and any details that may be necessary to reproduce the bug, including your gem version, Ruby version, and operating system. Ideally, a bug report should include a pull request with failing specs.

## Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `rspec`. If your specs pass, return to step 3. In the spirit of Test-Driven Development, you want to write a failing test first, then implement the feature or bug fix to make the test pass.
5. Implement your feature or bug fix.
6. Run `rspec`. If your specs fail, return to step 5.
7. Run `metric_fu -r`. This will go through all the files in the app and analyze the code quality and check for things like trailing whitespaces and hard tabs. When it's done, it will open a page in your browser with the results. Click on `Cane` and `Rails Best Practices` to check for files containing trailing whitespaces and hard tabs. If you use Sublime Text 2, you can use the [TrailingSpaces](https://github.com/SublimeText/TrailingSpaces) plugin to highlight the trailing whitespaces and delete them. If the report complains about "hard tabs" in a file, change your indentation to `spaces` by clicking on `Tabs: 2` at the bottom of your Sublime Text 2 window, then selecting `Convert Indentation to Spaces`. As for the code itself, we try to follow [GitHub's Ruby styleguide](https://github.com/styleguide/ruby).
8. Add, commit, and push your changes.
9. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/

## Supported Ruby Version
This library aims to support and is [tested against](http://travis-ci.org/codeforamerica/ohana-web-search) Ruby version 2.1.1.

If something doesn't work on this version, it should be considered a bug.

This library may inadvertently work (or seem to work) on other Ruby implementations, however support will only be provided for the version above.

If you would like this library to support another Ruby version, you may volunteer to be a maintainer. Being a maintainer entails making sure all tests run and pass on that implementation. When something breaks on your implementation, you will be personally responsible for providing patches in a timely fashion. If critical issues for a particular implementation exist at the time of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-web-search/blob/master/LICENSE.md) for details.
