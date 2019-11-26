FROM ruby:2.6.5

RUN apt-get update -qq

ENV job /job
RUN mkdir $job
WORKDIR $job
ADD . $job

RUN bundle install

CMD ruby api_logger.rb