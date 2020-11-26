FROM ruby:2.6.5-alpine

# install required alpine packages
RUN apk update && apk add build-base nodejs postgresql-dev sqlite
RUN apk add --update tzdata
# https://tips.tutorialhorizon.com/2017/08/29/tzinfodatasourcenotfound-when-using-alpine-with-docker/

# set working directory
RUN mkdir /app
WORKDIR /app

# install needed rails items
RUN gem install bundler
RUN gem install rails
RUN gem install tzinfo-data
RUN gem install tzinfo

# copy what we need to copy
COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs

COPY . .