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

WORKDIR /ohana-web-search

COPY Gemfile /ohana-web-search
COPY Gemfile.lock /ohana-web-search
COPY package.json /ohana-web-search

RUN gem install bundler --conservative
RUN bundle check || bundle install --jobs 20 --retry 5

COPY . /ohana-web-search

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
