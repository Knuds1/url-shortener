FROM ruby:3.1.1-bullseye

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install --deployment

COPY . .

ENV APP_ENV=production
ENV NANOID_SIZE=11

EXPOSE 80
CMD ["./bin/start.sh"]