FROM ruby:2.3.3

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

# PhantomJS is required for running tests
ENV PHANTOMJS_SHA256 86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f

RUN mkdir /usr/local/phantomjs \
  && curl -o phantomjs.tar.bz2 -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
  && echo "$PHANTOMJS_SHA256 *phantomjs.tar.bz2" | sha256sum -c - \
  && tar -xjf phantomjs.tar.bz2 -C /usr/local/phantomjs --strip-components=1 \
  && rm phantomjs.tar.bz2

RUN ln -s ../phantomjs/bin/phantomjs /usr/local/bin/

WORKDIR /SMC-Connect

COPY Gemfile /SMC-Connect
COPY Gemfile.lock /SMC-Connect

RUN bundle install

COPY . /SMC-Connect

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
