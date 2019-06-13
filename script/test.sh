#!/bin/sh

echo start rspec tests
docker-compose up -d

docker exec -it gem_test_runner bash -c "bundle install && bundle exec rspec $*"
