#Ohana Web Search

[![Build Status](https://travis-ci.org/codeforamerica/ohana-web-search.png?branch=master)](https://travis-ci.org/codeforamerica/ohana-web-search) [![Coverage Status](https://coveralls.io/repos/codeforamerica/ohana-web-search/badge.png?branch=master)](https://coveralls.io/r/codeforamerica/ohana-web-search) [![Dependency Status](https://gemnasium.com/codeforamerica/ohana-web-search.png)](https://gemnasium.com/codeforamerica/ohana-web-search)
[![Stories in Ready](https://badge.waffle.io/codeforamerica/ohana-web-search.png?label=ready)](https://waffle.io/codeforamerica/ohana-web-search) [![Code Climate](https://codeclimate.com/github/codeforamerica/ohana-web-search.png)](https://codeclimate.com/github/codeforamerica/ohana-web-search)

Ohana Web Search is one of two Rails apps that come out of the box with the [Ohana API](https://github.com/codeforamerica/ohana-api) platform. The other app is an [admin interface](https://github.com/codeforamerica/ohana-api-admin) that allows people to update the data. Both apps also serve as examples of what can be built on top of the social services data that the Ohana API exposes.

This project was developed by [Code for America's 2013 San Mateo County, CA,](http://codeforamerica.org/2013-partners/san-mateo-county/) fellowship team. Thanks to a [grant from the Knight Foundation](http://www.knightfoundation.org/grants/201447979/), [@monfresh](https://github.com/monfresh), [@spara](https://github.com/spara), and [@anselmbradford](https://github.com/anselmbradford) will continue to push code in 2014.

Ohana Web Search aims to make it easy to find available services in a community, and to provide as much pertinent information as possible, such as travel directions, hours of operation, other services residents in need might be eligible for, etc.
You can see a live example for services in San Mateo County, CA, here: [http://smc-connect.org](http://smc-connect.org)

We gladly welcome contributions. Below you will find instructions for installing the project and contributing.

## Demo
You can see a running version of the application at
[http://ohana-web-search-demo.herokuapp.com/](http://ohana-web-search-demo.herokuapp.com/).

## Stack Overview

* Ruby version 2.1.1
* Rails version 4.0.4
* Template Engines: ERB and HAML
* Testing Frameworks: RSpec, Capybara, capybara-webkit

## Deploying to Heroku
See the [Wiki](https://github.com/codeforamerica/ohana-web-search/wiki/How-to-deploy-Ohana-Web-Search-to-your-Heroku-account).

## Local Installation

Follow the instructions in [INSTALL.md][install].

[install]: https://github.com/codeforamerica/ohana-web-search/blob/master/INSTALL.md

## Adjusting the number of results per page
The Ohana API now supports the ability to set the number of results you want returned per page via the `per_page` parameter (with a maximum value of 100). If you want to view a different number of results per page, add `&per_page=1` or similar to the end of the URL.

## Running the tests
To test locally, you can run tests with this simple command:

    rspec

To configure the way RSpec displays test results, create a file called `.rspec` in the root directory, and add the following to it:

    --color
    --format documentation

The `--color` option allows you to see passing tests in green and failing ones in red. Otherwise, by default, you would just see a series of dots for passing tests, and the letter "F" for failing ones.

Parameters for the `--format` option are: `progress` (default - shows a series of dots), `documentation`, `html`, or `textmate`. [More information can be found on the RSpec website](https://www.relishapp.com/rspec/rspec-core/v/2-0/docs/configuration/read-command-line-configuration-options-from-files).

For faster tests (optional):

    gem install zeus
    zeus start #in a separate Terminal window or tab
    zeus rspec spec

Read more about [Zeus](https://github.com/burke/zeus).

To see the actual tests, browse through the [spec](https://github.com/codeforamerica/ohana-web-search/tree/master/spec) directory.

## Contributing
We'd love to get your help developing this project! Take a look at the [Contribution Document](https://github.com/codeforamerica/ohana-web-search/blob/master/CONTRIBUTING.md) to see how you can make a difference.

## Supported Ruby Version
This library aims to support and is [tested against](http://travis-ci.org/codeforamerica/ohana-web-search) Ruby version 2.1.1.

If something doesn't work on this version, it should be considered a bug.

This library may inadvertently work (or seem to work) on other Ruby implementations, however support will only be provided for the version above.

If you would like this library to support another Ruby version, you may volunteer to be a maintainer. Being a maintainer entails making sure all tests run and pass on that implementation. When something breaks on your implementation, you will be personally responsible for providing patches in a timely fashion. If critical issues for a particular implementation exist at the time of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/codeforamerica/ohana-web-search/blob/master/LICENSE.md) for details.
