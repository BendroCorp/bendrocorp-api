FROM ruby:2.6.5-alpine

RUN apk update && apk add build-base nodejs postgresql-dev

RUN mkdir /app
WORKDIR /app

RUN gem install bundler
RUN gem install rails

COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .