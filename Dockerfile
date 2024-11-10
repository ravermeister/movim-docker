FROM arm64v8/debian:stable-slim AS base

LABEL org.opencontainers.image.authors="Jonny Rimkus <jonny@rimkus.it>" \
description="Movim Arm Docker Image based on debian-slim"
SHELL ["/bin/sh", "-c"]
ENV LANG=C.UTF-8
# Install required packages
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive \
    && apt-get update -q \
    && apt-get install -yq --no-install-recommends \
      apt-transport-https ca-certificates less nano \
      tzdata libatomic1 wget make xz-utils git nginx \
      unzip libmagickwand-dev libjpeg-dev libpng-dev libwebp-dev libpq-dev libzip-dev \
      composer php-fpm php-curl php-mbstring php-imagick php-gd php-pgsql php-xml php-dev php-pear \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
#    # Remove MOTD
    && rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic \
    && ln -fs /dev/null /run/motd.dynamic

# install php modules
RUN printf "\n" | pecl install imagick zip

# PHP Settings for movim
COPY assets/movim.ini /etc/php/conf.d/movim.ini
RUN ln -s /etc/php/conf.d/movim.ini $(find /etc/php -type d -name mods-available)/movim.ini \
    && phpenmod movim \
    && phpenmod movim

# PHP FPM Settings
COPY assets/movim-fpm.conf /etc/php/pool.d/movim.conf
RUN ln -s /etc/php/pool.d/movim.conf $(find /etc/php -type d -name pool.d)/movim.ini

# add init script
COPY assets/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# add nginx config
COPY assets/movin-nginx.conf /etc/nginx/sites-available/default

# create movim user
RUN useradd -r -d /usr/local/share/movim movim

# switch to movim user
USER movim
WORKDIR /usr/local/share/movim

# install movim
FROM base AS movim

ARG MOVIM_GIT_REPO=https://github.com/movim/movim.git
ARG MOVIM_VERSION=v0.28

RUN git clone $MOVIM_GIT_REPO /usr/local/share/movim \
    && cd /usr/local/share/movim \
    && git checkout $MOVIM_VERSION \
    && composer install \
    && mkdir -p cache log public/cache

# we need to be root first, 
# because the entrypoint.sh starts php-fpm and nginx before
# the movin daemon
USER root

EXPOSE 80 8080
ENTRYPOINT /usr/local/bin/entrypoint.sh
