FROM ruby:3

ADD . /app
WORKDIR /app
RUN bundle install

EXPOSE 4567

CMD ["/bin/bash"]
