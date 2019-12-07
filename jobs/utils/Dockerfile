# The base image from which jobs in this dir inherit from
FROM ruby:2.6.5

RUN apt-get update -qq

ENV utils /utils
RUN mkdir $utils
WORKDIR $utils
ADD . $utils

# Install all required gems used by utils/
RUN bundle install