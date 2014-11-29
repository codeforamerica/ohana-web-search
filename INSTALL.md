
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
- [PhantomJS][phantomjs] (only used for running the tests)
- [Node.js][node] (Linux only)

[build-tools]: https://github.com/codeforamerica/howto/blob/master/Build-Tools.md
[ruby]: https://github.com/codeforamerica/howto/blob/master/Ruby.md
[phantomjs]: https://github.com/jonleighton/poltergeist#installing-phantomjs
[node]: https://github.com/codeforamerica/howto/blob/master/Node.js.md


## Install Ohana Web Search

### Fork and clone

[Fork this repository to your GitHub account][fork].

Clone it on your computer and navigate to the project's directory:

    git clone https://github.com/<your GitHub username>/ohana-web-search.git
    cd ohana-web-search

[fork]: http://help.github.com/fork-a-repo/

### Install the dependencies:

    bundle

### Configure environment variables
Inside the `config` folder, you will find a file named `application.example.yml`.
Copy its contents to a new file called `application.yml` in the same directory.

### Run the app
Start the app locally on port 4000:

    rails s -p 4000

Ohana Web Search should now be running at [http://localhost:4000](http://localhost:4000)

The `-p` option allows you to specify which port you want to run the server on. This is useful when running other apps at the same time.
