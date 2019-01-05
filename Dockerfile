FROM ruby:2.5.3

RUN apt-get update && apt-get install apt-transport-https

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get install -y nodejs

# Install yarn
ADD https://dl.yarnpkg.com/debian/pubkey.gpg /tmp/yarn-pubkey.gpg
RUN apt-key add /tmp/yarn-pubkey.gpg && rm /tmp/yarn-pubkey.gpg
RUN echo 'deb https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends yarn

# PhantomJS is required for running tests
ENV PHANTOMJS_SHA256 86dd9a4bf4aee45f1a84c9f61cf1947c1d6dce9b9e8d2a907105da7852460d2f

RUN mkdir /usr/local/phantomjs \
  && curl -o phantomjs.tar.bz2 -L https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 \
  && echo "$PHANTOMJS_SHA256 *phantomjs.tar.bz2" | sha256sum -c - \
  && tar -xjf phantomjs.tar.bz2 -C /usr/local/phantomjs --strip-components=1 \
  && rm phantomjs.tar.bz2

RUN ln -s ../phantomjs/bin/phantomjs /usr/local/bin/

WORKDIR /ohana-web-search

COPY Gemfile /ohana-web-search
COPY Gemfile.lock /ohana-web-search
COPY package.json /ohana-web-search

RUN gem install bundler --conservative
RUN bundle check || bundle install --jobs 20 --retry 5

COPY . /ohana-web-search

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
