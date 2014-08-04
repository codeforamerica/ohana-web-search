# Running Ohana Web Search on your computer

## Install Prerequisites

Before you can run Ohana Web Search, you'll need to have the following software
packages installed on your computer: Git, Ruby 2.1+, RVM, and PhantomJS.
If you're on a Linux machine, you'll also need Node.js.

If you already have all of the prerequisites installed, you can go straight
to the [Installation](#install-ohana-web-search). Otherwise, you'll need to
install the following tools manually:

- [Build tools][build-tools]
- [Ruby with RVM][ruby]
- [Qt][qt] (only used for running the tests)
- [Node.js][node] (Linux only)

[build-tools]: https://github.com/codeforamerica/howto/blob/master/Build-Tools.md
[ruby]: https://github.com/codeforamerica/howto/blob/master/Ruby.md
[qt]: https://github.com/codeforamerica/ohana-web-search/wiki/Installing-Qt
[node]: https://github.com/codeforamerica/howto/blob/master/Node.js.md


## Install Ohana Web Search

### Fork and clone

[Fork this repository to your GitHub account][fork].

Clone it on your computer and navigate to the project's directory:

    git clone https://github.com/<your GitHub username>/ohana-web-search.git && cd ohana-web-search

[fork]: http://help.github.com/fork-a-repo/

### Install the dependencies:

    bundle

### Set up the environment variables & customizable settings

#### Configure environment variables
1. __Add an environment variables file__. Inside the `config` folder, you will find a file named `application.example.yml`.
Copy its contents to a new file called `application.yml` in the same directory.
Read through the documentation to learn how you can customize the app to suit
your needs.

2. __Set API URL the app feeds from__. By default, the app is configured to point to the demo API at
`http://ohana-api-demo.herokuapp.com/api`. To point to your own instance of
Ohana API, change the value of `OHANA_API_ENDPOINT` in your `application.yml` file.

#### Adjust customizable settings
_This step is only necessary if you are planning on customizing the app with_
_the intent of deploying it. If you just want to submit a pull request, you can_
_use the default `settings.yml`._

Inside the `config` folder, you will also find a file called `settings.yml`.
In that file, there are many settings you can, and should, customize.
Read through the documentation to learn how you can customize the app to suit
your needs.

#### Customizing the map marker graphics
The root `graphics` folder contains source files for images in the application. In this directory you can find an Adobe Illustrator source file for the Google map marker graphics. With this file you can adjust the map marker appearance by making changes and exporting and overwriting the files in `/app/assets/images/markers`. The Google map appears on the search results and location details pages.

#### Adding JavaScript code
Ohana Web Search doesn't use the default `application.js` manifest file for loading JavaScript files that may be
found in a default Rails install. Instead it uses a modular JavaScript pattern through the [requirejs-rails gem](https://github.com/jwhitley/requirejs-rails). More information about this setup can be found in the modified
[application.js][applicationjs] file and the [RequireJS configuration][requirejsconfig] file.


### Run the app
Start the app locally on port 4000:

    rails s -p 4000

Ohana Web Search should now be running at [http://lvh.me:4000](http://lvh.me:4000)

The `-p` option allows you to specify which port you want to run the server on. This is useful when running other servers at the same time. For example, if you're also running [Ohana API Admin][admin] locally (which uses port 3000 by default), you wouldn't be able to run Ohana Web Search with the simple `rails s` command, because it would also default to port 3000. By specifying a different port number, you can run both servers at the same time.

Please make sure you are using `lvh.me` instead of `localhost` to be able to test the translation feature. Read more about [lvh.me](http://matthewhutchinson.net/2011/1/10/configuring-subdomains-in-development-with-lvhme).

[admin]: https://github.com/codeforamerica/ohana-api-admin
[applicationjs]: https://github.com/codeforamerica/ohana-web-search/blob/master/app/assets/javascripts/application.js
[requirejsconfig]: https://github.com/codeforamerica/ohana-web-search/blob/master/config/requirejs.yml
