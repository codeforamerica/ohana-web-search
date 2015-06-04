#Ohana Web Search

[![Build Status](https://travis-ci.org/codeforamerica/ohana-web-search.png?branch=master)](https://travis-ci.org/codeforamerica/ohana-web-search) [![Coverage Status](https://coveralls.io/repos/codeforamerica/ohana-web-search/badge.png?branch=master)](https://coveralls.io/r/codeforamerica/ohana-web-search?branch=master) [![Dependency Status](https://gemnasium.com/codeforamerica/ohana-web-search.png)](https://gemnasium.com/codeforamerica/ohana-web-search) [![Code Climate](https://codeclimate.com/github/codeforamerica/ohana-web-search.png)](https://codeclimate.com/github/codeforamerica/ohana-web-search)

Ohana Web Search is the web-based search portion of the [Ohana](http://ohanapi.org) project. It requires connecting to your own instance of [Ohana API](https://github.com/codeforamerica/ohana-api), which will provide the data to Ohana Web Search.

This project was developed by [Code for America's 2013 San Mateo County, CA,](http://codeforamerica.org/2013-partners/san-mateo-county/) fellowship team. Thanks to a [grant from the Knight Foundation](http://www.knightfoundation.org/grants/201447979/), [@monfresh](https://github.com/monfresh), [@spara](https://github.com/spara), and [@anselmbradford](https://github.com/anselmbradford) will continue to push code in 2014.

Ohana Web Search aims to make it easy to find available services in a community, and to provide as much pertinent information as possible, such as travel directions, hours of operation, other services residents in need might be eligible for, etc.
You can see a live example for services in San Mateo County, CA, here: [http://smc-connect.org](http://smc-connect.org)

We gladly welcome contributions. Below you will find instructions for installing the project and contributing.

## Demo
You can see a running version of the application at
[https://ohana-web-search-demo.herokuapp.com/](https://ohana-web-search-demo.herokuapp.com/).

## Stack Overview

* Ruby version 2.2.1
* Rails version 4.2.1
* Template Engines: ERB and HAML
* Testing Frameworks: RSpec, Capybara, Poltergeist

## Deploying to Heroku
See the [Wiki](https://github.com/codeforamerica/ohana-web-search/wiki/How-to-deploy-Ohana-Web-Search-to-your-Heroku-account).

## Local Installation (for developers)

Follow the instructions in [INSTALL.md][install].

[install]: https://github.com/codeforamerica/ohana-web-search/blob/master/INSTALL.md

## Customization

Follow the instructions in [CUSTOMIZE.md][customize].

[customize]: https://github.com/codeforamerica/ohana-web-search/blob/master/CUSTOMIZE.md

## Running the tests
To test locally, you can run tests with this simple command:

    script/test

To configure the way RSpec displays test results, create a file called `.rspec` in the root directory, and add the following to it:

    --color
    --format progress

The `--color` option allows you to see passing tests in green and failing ones in red. Otherwise, by default, you would just see a series of dots for passing tests, and the letter "F" for failing ones.

Parameters for the `--format` option are: `progress` (default - shows a series of dots), `documentation`, `html`, or `textmate`. [More information can be found on the RSpec website](https://www.relishapp.com/rspec/rspec-core/v/3-0/docs/configuration/read-command-line-configuration-options-from-files).

To see the actual tests, browse through the [spec](https://github.com/codeforamerica/ohana-web-search/tree/master/spec) directory.

## Contributing
We'd love to get your help developing this project! Take a look at the [Contribution Document](https://github.com/codeforamerica/ohana-web-search/blob/master/CONTRIBUTING.md) to see how you can make a difference.

## Copyright
Copyright (c) 2013-2014 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-web-search/blob/master/LICENSE.md) for details.
