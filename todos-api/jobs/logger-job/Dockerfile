FROM ruby:2.6.5

RUN apt-get update -qq

ENV job /job
RUN mkdir $job
WORKDIR $job
ADD . $job

RUN bundle install