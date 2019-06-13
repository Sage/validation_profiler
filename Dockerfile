FROM ruby:2.3-alpine

RUN apk add --no-cache --update bash

RUN apk add --no-cache --update --virtual .gem-builddeps make gcc libc-dev ruby-json \
    && gem install -N oj -v 2.15.0 \
    && gem install -N json -v 2.2.0 \
    && gem install -N byebug -v 11.0.1 \
    && apk del .gem-builddeps

# Create application directory and set it as the WORKDIR.
ENV APP_HOME /validation_profiler
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY . $APP_HOME

RUN bundle install --system --binstubs
