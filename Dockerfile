FROM ruby:2.3.3-alpine

ENV RAILS_ENV=production RACK_ENV=production
ENV SECRET_KEY_BASE=change_me

RUN mkdir /app
WORKDIR /app

# Upgrade, install dependency, and clean
RUN apk --update --upgrade --no-cache add \
    build-base \
    git \
    nodejs \
    postgresql-dev \
    tzdata \
    && rm -rf /var/cache/apk/*

COPY Gemfile* /app/

# Install gems
RUN bundle install --deployment --without development test

COPY . /app

# Precompile assets
RUN bundle exec rake assets:precompile

CMD ["bundle", "exec", "puma", "--help"]

VOLUME /app/public
