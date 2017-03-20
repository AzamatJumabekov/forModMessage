FROM ruby:alpine

RUN apk update
RUN apk upgrade
RUN apk add curl wget bash

RUN mkdir /app
RUN touch /var/tmp/file

WORKDIR /app

ADD ./ /app