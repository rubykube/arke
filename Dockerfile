FROM ruby:2.6.1

MAINTAINER aartemiev@heliostech.fr

ENV APP_HOME=/home/app

ARG UID=1000
ARG GID=1000

RUN groupadd -r --gid ${GID} app \
 && useradd --system --create-home --home ${APP_HOME} --shell /sbin/nologin --no-log-init \
--gid ${GID} --uid ${UID} app

USER app
WORKDIR $APP_HOME

COPY --chown=app:app . .

RUN gem update bundler && bundle install

ENTRYPOINT ["bin/arke"]
