FROM ruby:2.6.5-alpine

# install required alpine packages
RUN apk update && apk add build-base nodejs postgresql-dev
RUN apk add --update tzdata

# set working directory
RUN mkdir /app
WORKDIR /app

# install needed rails items
RUN gem install bundler
RUN gem install rails
RUN tzinfo-data
RUN tzinfo

# copy what we need to copy
COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .