# Running SMC-Connect on your computer

## Install Prerequisites
Before you can run SMC-Connect, you'll need to have the following software
packages installed on your computer: Git, Ruby 2.1+, RVM, and PhantomJS.
If you're on a Linux machine, you'll also need Node.js.

If you already have all of the prerequisites installed, you can go straight
to the [Installation](#install-smc-connect). Otherwise, you'll need to
install the following tools manually:

- [Build tools][build-tools]
- [Ruby with RVM][ruby]
- [PhantomJS][phantomjs] (only used for running the tests)
- [Node.js][node] (Linux only)

[build-tools]: https://github.com/codeforamerica/howto/blob/master/Build-Tools.md
[ruby]: https://github.com/codeforamerica/howto/blob/master/Ruby.md
[phantomjs]: https://github.com/jonleighton/poltergeist#installing-phantomjs
[node]: https://github.com/codeforamerica/howto/blob/master/Node.js.md

## Install SMC-Connect

### Fork and clone
[Fork this repository to your GitHub account][fork].

Clone it on your computer and navigate to the project's directory:

    git clone https://github.com/<your GitHub username>/smc-connect.git && cd smc-connect

[fork]: http://help.github.com/fork-a-repo/

### Install the dependencies:

    bundle

### Set up the environment variables & customizable settings

#### Configure environment variables
Inside the `config` folder, you will find a file named `application.example.yml`.
Copy its contents to a new file called `application.yml` in the same directory.
The settings are already configured for use with http://smc-connect.org,
but can be customized if needed.

#### Adjust customizable settings
Inside the `config` folder, you will also find a file called `settings.yml`.
The settings are already configured for use with http://smc-connect.org,
but can be customized if needed.

#### Customizing the map marker graphics
The root `graphics` folder contains source files for images in the application. In this directory, you can find an Adobe Illustrator source file for the Google map marker graphics. With this file, you can adjust the map marker appearance by making changes and exporting and overwriting the files in `/app/assets/images/markers`. The Google map appears on the search results and location details pages.

#### Adding JavaScript code
Ohana Web Search doesn't use the default `application.js` manifest file for
loading JavaScript files that may be found in a default Rails install. Instead
it uses a modular JavaScript pattern through the
[requirejs-rails gem](https://github.com/jwhitley/requirejs-rails). More
information about this setup can be found in the modified
[application.js][applicationjs] file and the
[RequireJS configuration][requirejsconfig] file.

[applicationjs]: https://github.com/codeforamerica/ohana-web-search/blob/master/app/assets/javascripts/application.js
[requirejsconfig]: https://github.com/codeforamerica/ohana-web-search/blob/master/config/requirejs.yml

### Run the app
Start the app locally on port 4000:

    rails s -p 4000

SMC-Connect should now be running at [http://localhost:4000](http://localhost:4000)

The `-p` option allows you to specify which port you want to run the server on. This is useful when running other servers at the same time.

If you want to test the Google Translate feature in development, you'll need to clear your browser cookies for the site, then visit the site using `lvh.me` instead of `localhost`. Read more about [lvh.me](http://matthewhutchinson.net/2011/1/10/configuring-subdomains-in-development-with-lvhme).
