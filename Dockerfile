FROM arm64v8/debian:stable-slim AS base

LABEL org.opencontainers.image.authors="Jonny Rimkus <jonny@rimkus.it>" \
description="Movim Arm Docker Image based on debian-slim"
SHELL ["/bin/sh", "-c"]
ENV LANG=C.UTF-8
# Install required packages
RUN set -eux; \
    export DEBIAN_FRONTEND=noninteractive &&\
    apt-get update -q &&\
    apt-get install -yq --no-install-recommends \
      apt-transport-https ca-certificates less nano \
      tzdata libatomic1 wget \
      unzip libmagickwand-dev libjpeg-dev libpng-dev libwebp-dev libpq-dev libzip-dev \
      composer php-fpm php-curl php-mbstring php-imagick php-gd php-pgsql php-xml \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
#    # Remove MOTD
    && rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic \
    && ln -fs /dev/null /run/motd.dynamic

# PHP Settings for movim
RUN mkdir /etc/php/conf.d \
 && echo 'opcache.memory_consumption=128' >>/etc/php/conf.d/movim.ini \
 && echo 'opcache.interned_strings_buffer=8' >>/etc/php/conf.d/movim.ini \
 && echo 'opcache.max_accelerated_files=4000' >>/etc/php/conf.d/movim.ini \
 && echo 'opcache.revalidate_freq=2' >>/etc/php/conf.d/movim.ini \
 && echo 'opcache.fast_shutdown=1' >>/etc/php/conf.d/movim.ini \
 && echo 'opcache.enable_cli=1' >>/etc/php/conf.d/movim.ini \
 && ln -s /etc/php/conf.d/movim.ini $(find /etc/php -type d -name mods-available)/movim.ini \
 && phpenconf movim


FROM base AS movim
RUN echo "Hello from movim docker"
