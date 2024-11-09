FROM arm64v8/debian:stable-slim as base
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
    # Remove MOTD
    && rm -rf /etc/update-motd.d /etc/motd /etc/motd.dynamic \
    && ln -fs /dev/null /run/motd.dynamic \
    # Remove generated SSH Keys
    && rm /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key.pub \
    /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key.pub \
    /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key.pub >/dev/null 2>&1


#RUN { \
#		echo 'opcache.memory_consumption=128'; \
#		echo 'opcache.interned_strings_buffer=8'; \
#		echo 'opcache.max_accelerated_files=4000'; \
#		echo 'opcache.revalidate_freq=2'; \
#		echo 'opcache.fast_shutdown=1'; \
#		echo 'opcache.enable_cli=1'; \
#	} > /etc/php/conf.d/opcache-recommended.ini \
#    && phpenconf


FROM base as movim
RUN echo "Hello from movim docker"
