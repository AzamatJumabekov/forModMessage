FROM ruby:2.3.1-alpine

MAINTAINER Azamat Jumabekov <azamat.jumabekov@gmail.com>

# Install base packages
RUN apk update
RUN apk upgrade
RUN apk add alpine-sdk

ENV RACK_ENV=production

RUN gem install bundler --version 1.14.5 --no-ri

COPY Gemfile* /tmp/

WORKDIR /tmp
RUN bundle install

ENV app /app
RUN mkdir $app
WORKDIR $app

EXPOSE 3000

COPY . $app