FROM ruby:alpine

RUN apk update
RUN apk upgrade
RUN apk add curl wget bash

RUN mkdir /app

WORKDIR /app

ADD app.rb /app