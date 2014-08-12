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

Inside the `config` folder, you will find a file named `application.example.yml`.
Copy its contents to a new file called `application.yml`.

By default, the app is configured to point to the demo API at
`http://ohanapi.herokuapp.com/api`. To point to your own instance of
Ohana API, change the value of `OHANA_API_ENDPOINT` in your `application.yml`.

Note that if you had previously installed this repo locally, you will need to update your `application.yml` to point to the new demo API, or any v2.0.0 Ohana API.

Inside the `config` folder, you will also find a file called `settings.yml`.
In that file, there are many settings you can customize. Please read through
the instructions in that file carefully.

### Run the app
Start the app locally on port 4000:

    rails s -p 4000

SMC-Connect should now be running at [http://lvh.me:4000](http://lvh.me:4000)

The `-p` option allows you to specify which port you want to run the server on. This is useful when running other servers at the same time. For example, if you're also running [Ohana API Admin][admin] locally (which uses port 3000 by default), you wouldn't be able to run SMC-Connect with the simple `rails s` command, because it would also default to port 3000. By specifying a different port number, you can run both servers at the same time.

Please make sure you are using `lvh.me` instead of `localhost` to be able to test the translation feature. Read more about [lvh.me](http://matthewhutchinson.net/2011/1/10/configuring-subdomains-in-development-with-lvhme).

[admin]: https://github.com/smcgov/SMC-Connect-Admin