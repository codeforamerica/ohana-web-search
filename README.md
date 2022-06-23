#SMC-Connect

[![CircleCI](https://circleci.com/gh/smcgov/SMC-Connect/tree/master.svg?style=svg)](https://circleci.com/gh/smcgov/SMC-Connect/tree/master) [![Maintainability](https://api.codeclimate.com/v1/badges/c83da1660a5df77aa361/maintainability)](https://codeclimate.com/github/smcgov/SMC-Connect/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/c83da1660a5df77aa361/test_coverage)](https://codeclimate.com/github/smcgov/SMC-Connect/test_coverage)
[![View performance data on Skylight](https://badges.skylight.io/status/OsRyw4RiuAcN.svg)](https://oss.skylight.io/app/applications/OsRyw4RiuAcN)

[SMC-Connect](https://www.smc-connect.org) is a Ruby on Rails app that makes it easy to find human services, farmers' markets, and other community organizations in San Mateo County, California.

The app is powered by the [Ohana API](https://github.com/codeforamerica/ohana-api) platform which was developed by [Code for America's 2013 San Mateo County, CA,](https://codeforamerica.org/2013-partners/san-mateo-county/) fellowship team: [@monfresh](https://github.com/monfresh), [@spara](https://github.com/spara), and [@anselmbradford](https://github.com/anselmbradford).

In San Mateo County, there are two apps powered by Ohana: [SMC-Connect](https://www.smc-connect.org) and the [San Mateo County API](https://github.com/smcgov/ohana-api-smc) (that feeds the data to SMC-Connect). The API also comes with a built-in admin interface that allows organization members to update their own data. The updates are reflected in real-time on SMC-Connect.

## Demo
You can see a running version of the application at
[https://www.smc-connect.org](https://www.smc-connect.org).

## Stack Overview

* Ruby version 3.1.2
* Rails version 6.1.5.1
* Node.js 16.x
* Yarn 1.x
* Template Engines: ERB and HAML
* Testing Frameworks: RSpec, Capybara, Poltergeist

## Deploying to Heroku
See the [Ohana Web Search Wiki](https://github.com/codeforamerica/ohana-web-search/wiki/How-to-deploy-Ohana-Web-Search-to-your-Heroku-account).

## Local Installation (for developers)
Follow the instructions in [INSTALL.md][install].

[install]: https://github.com/smcgov/SMC-Connect/blob/master/INSTALL.md

## Customization
Follow the instructions in [CUSTOMIZE.md][customize].

[customize]: https://github.com/smcgov/SMC-Connect/blob/master/CUSTOMIZE.md

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

## Copyright
Copyright (c) 2013-2014 Code for America. See [LICENSE](https://github.com/smcgov/smc-connect/blob/master/LICENSE.md) for details.
