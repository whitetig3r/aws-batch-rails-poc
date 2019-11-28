# The base image from which jobs in this dir inherit from
FROM ruby:2.6.5

RUN apt-get update -qq

ENV base /base
RUN mkdir $base
WORKDIR $base
ADD . $base

# Install all required gems used by utils/
RUN bundle install