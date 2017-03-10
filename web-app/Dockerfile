FROM ruby:2.3.1-alpine

# Install base packages
RUN apk update --no-cache
RUN apk upgrade --no-cache
RUN apk add alpine-sdk --no-cache

RUN gem install bundler --version 1.14.5 --no-ri

COPY Gemfile* /tmp/

WORKDIR /tmp
RUN bundle install

ENV app /app
RUN mkdir $app
WORKDIR $app

COPY . $app