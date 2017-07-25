FROM ruby:2.3.1-slim

RUN apt-get update && apt-get install -qq -y curl build-essential libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get update && apt-get install -qq -y nodejs
RUN npm i -g bower

RUN mkdir -p /jsonapi-schema-generator

WORKDIR /jsonapi-schema-generator

ADD . /jsonapi-schema-generator

RUN cd app/frontend && npm i && bower i --allow-root && npm rebuild node-sass && ./node_modules/ember-cli/bin/ember build --environment=production && mv -f ./dist/* /jsonapi-schema-generator/public

RUN bundle install




