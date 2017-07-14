FROM ruby:2.3.1-slim

RUN apt-get update && apt-get install -qq -y build-essential nodejs libpq-dev postgresql-client-9.4 --fix-missing --no-install-recommends

RUN mkdir -p /jsonapi-schema-generator

WORKDIR /jsonapi-schema-generator

ADD . /jsonapi-schema-generator

RUN bundle install




