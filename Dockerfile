FROM ruby:3-alpine
RUN apk add --no-cache --update \
    build-base \
    ruby-dev

RUN
ADD . /app
WORKDIR /app
RUN bundle install

EXPOSE 4567

CMD ["/bin/bash"]
