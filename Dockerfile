FROM ruby:2.6.3 as base

ENV BUNDLE_PATH /bundle
ENV RAILS_LOG_TO_STDOUT 1

ENV APP_HOME /home/app
WORKDIR $APP_HOME

RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  default-libmysqlclient-dev \
  dumb-init \
  git \
  libssl-dev \
  libxslt-dev \
  openssh-client \
  unzip \
  zlib1g-dev \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

ARG BUNDLER_VERSION=2.1.4
RUN gem install bundler -v "${BUNDLER_VERSION}"

ARG BUNDLE_WITHOUT="test"
COPY Gemfile* ./
RUN bundle install --without ${BUNDLE_WITHOUT}

COPY . .

ARG RAILS_ENV=development
ENV RAILS_ENV ${RAILS_ENV}

EXPOSE 3000

ENTRYPOINT ["sh", "./app.sh"]