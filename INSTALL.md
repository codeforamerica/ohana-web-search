
# Running Ohana Web Search on your computer

## Install Prerequisites

Before you can run Ohana Web Search, you'll need to have the following software
packages installed on your computer: Git, Ruby 2.2+, RVM, and PhantomJS.
If you're on a Linux machine, you'll also need Node.js.

If you already have all of the prerequisites installed, you can go straight
to the [Installation](#install-ohana-web-search). Otherwise, you'll need to
install the following tools manually:

- [Build tools][build-tools]
- [Ruby with RVM][ruby]
- [PhantomJS][phantomjs] (only used for running the tests)
- [Node.js][node] (Linux only)

[build-tools]: https://github.com/codeforamerica/howto/blob/master/Build-Tools.md
[ruby]: https://github.com/codeforamerica/howto/blob/master/Ruby.md
[phantomjs]: https://github.com/jonleighton/poltergeist#installing-phantomjs
[node]: https://github.com/codeforamerica/howto/blob/master/Node.js.md


## Install Ohana Web Search

Clone the `codeforamerica/ohana-web-search` repository and navigate to the project's directory:

    git clone git@github.com:codeforamerica/ohana-web-search.git
    cd ohana-web-search

### Install the dependencies and set the default environment variables:

    bin/setup

### Run the app
Start the app locally on port 4000:

    puma -p 4000

Ohana Web Search should now be running at [http://localhost:4000](http://localhost:4000)

The `-p` option allows you to specify which port you want to run the server on. This is useful when running other apps at the same time.

### Customize the app
Once you have the app up and running, you will want to [customize](https://github.com/codeforamerica/ohana-web-search/blob/master/CUSTOMIZE.md) it to point
to your own instance of [Ohana API](https://github.com/codeforamerica/ohana-api),
add your own branding, and much more.
