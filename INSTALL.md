# Running SMC-Connect on your computer

## Clone the repo to your local machine

    git clone git@github.com:smcgov/SMC-Connect.git && cd SMC-Connect

## Docker Setup (recommended, especially for Windows users)

1. Download, install, and launch [Docker]

1. Configure the docker image and run the app:

   `$ bin/setup --docker`

Once the docker images are up and running, the app will be accessible at
[http://localhost:3000](http://localhost:3000).

More useful Docker commands:

* Stop this running container: `docker-compose stop`
* Stop and delete the containers: `docker-compose down`
* Open a shell in the web container: `docker-compose run --rm web bash`

[Docker]: https://docs.docker.com/engine/installation/


## Local Setup

Before you can run SMC-Connect, you'll need to have the following software
packages installed on your computer:
- Git
- Ruby 2.3+
- RVM (or other Ruby version manager)
- Yarn 0.25.2+
- Node.js 6.0.0+

If you already have all of the prerequisites installed, you can skip to the
next step. Otherwise, there are two ways you can install the tools:

- If you're on a Mac, the easiest way to install all the tools is to use
@monfresh's [laptop] script.

- Install everything manually: [Build tools], [Ruby with RVM], and
[Node.js][node] (Linux only).

[laptop]: https://github.com/monfresh/laptop
[Build tools]: https://github.com/codeforamerica/howto/blob/master/Build-Tools.md
[Ruby with RVM]: https://github.com/codeforamerica/howto/blob/master/Ruby.md
[node]: https://github.com/codeforamerica/howto/blob/master/Node.js.md

### Install the dependencies and set the default environment variables:

    bin/setup

### Run the app
In one terminal window or tab, run the webpack dev server:

    ./bin/webpack-dev-server

In another terminal window or tab, start the app locally on port 4000:

    bundle exec puma -p 4000

SMC-Connect should now be running at [http://localhost:4000](http://localhost:4000)

The `-p` option allows you to specify which port you want to run the server on. This is useful when running other apps at the same time.
