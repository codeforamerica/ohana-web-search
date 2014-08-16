#SMC-Connect

[![Build Status](https://travis-ci.org/smcgov/SMC-Connect.png?branch=master)](https://travis-ci.org/smcgov/SMC-Connect) [![Coverage Status](https://coveralls.io/repos/smcgov/SMC-Connect/badge.png?branch=master)](https://coveralls.io/r/smcgov/SMC-Connect) [![Dependency Status](https://gemnasium.com/smcgov/SMC-Connect.png)](https://gemnasium.com/smcgov/SMC-Connect) [![Code Climate](https://codeclimate.com/github/smcgov/SMC-Connect.png)](https://codeclimate.com/github/smcgov/SMC-Connect)

[SMC-Connect](http://www.smc-connect.org) is a Ruby on Rails app that makes it easy to find human services, farmers' markets, and other community organizations in San Mateo County, California.

The app is powered by the [Ohana API](http://ohanapi.org) platform which was developed by [Code for America's 2013 San Mateo County, CA,](http://codeforamerica.org/2013-partners/san-mateo-county/) fellowship team: [@monfresh](https://github.com/monfresh), [@spara](https://github.com/spara), and [@anselmbradford](https://github.com/anselmbradford).

In San Mateo County, there are two apps powered by Ohana: [SMC-Connect](http://smc-connect.org) and the [San Mateo County API](https://github.com/smcgov/ohana-api-smc) (that feeds the data to SMC-Connect). The API also comes with a built-in admin interface that allows organization members to update their own data. The updates are reflected in real-time on SMC-Connect.

## Demo
You can see a running version of the application at
[http://smc-connect.org](http://smc-connect.org).

## Stack Overview
* Ruby version 2.1.1
* Rails version 4.1.4
* Template Engines: HAML
* Testing Frameworks: RSpec, Capybara and Poltergeist

## Local Installation
Follow the instructions in [INSTALL.md][install].

[install]: https://github.com/smcgov/SMC-Connect/blob/master/INSTALL.md

## Running the tests
To test locally, you can run tests with this simple command:

    script/test

To configure the way RSpec displays test results, create a file called `.rspec` in the root directory, and add the following to it:

    --color
    --format progress

The `--color` option allows you to see passing tests in green and failing ones in red.

Parameters for the `--format` option are: `progress` (default - shows a series of dots), `documentation`, `html`, or `textmate`. [More information can be found on the RSpec website](https://www.relishapp.com/rspec/rspec-core/v/3-0/docs/configuration/read-command-line-configuration-options-from-files).

To see the actual tests, browse through the [spec](https://github.com/smcgov/SMC-Connect/tree/master/spec) directory.

## Contributing
We'd love to get your help developing this project! Take a look at the [Contribution Document](https://github.com/smcgov/SMC-Connect/blob/master/CONTRIBUTING.md) to see how you can make a difference.

## Supported Ruby Version
This library aims to support and is [tested against](http://travis-ci.org/smcgov/SMC-Connect) Ruby version 2.1.1.

If something doesn't work on this version, it should be considered a bug.

This library may inadvertently work (or seem to work) on other Ruby implementations, however support will only be provided for the version above.

If you would like this library to support another Ruby version, you may volunteer to be a maintainer. Being a maintainer entails making sure all tests run and pass on that implementation. When something breaks on your implementation, you will be personally responsible for providing patches in a timely fashion. If critical issues for a particular implementation exist at the time of a major release, support for that Ruby version may be dropped.

## Copyright
Copyright (c) 2013 Code for America. See [LICENSE](https://github.com/smcgov/SMC-Connect/blob/master/LICENSE.md) for details.
