FROM ubuntu:20.04

MAINTAINER Chris Runo <chris@daggerhart.com>

ENV LC_ALL=C.UTF-8

CMD /bin/bash

# Ensure bash over sh.
RUN rm /bin/sh && \
	ln -s /bin/bash /bin/sh;

# Remove interactive shell for build.
ARG DEBIAN_FRONTEND=noninteractive

# Receive any core updates.
RUN apt-get update && \
	apt-get upgrade -yq && \
	apt-get dist-upgrade -yq;

# Install package dependencies.
RUN apt-get install -yq \
	apache2 \
	apt-transport-https \
	autoconf \
	automake \
	build-essential \
	bzip2 \
	ca-certificates \
	curl \
	file \
	gcc \
	g++ \
	git \
	imagemagick \
	libfontconfig \
	libfreetype6 \
	libssl-dev \
	make \
	patch \
	unzip;

# Install PHP dependencies.
RUN apt-get install -yq \
    libapache2-mod-php \
    php \
    php-bcmath \
    php-cli \
    php-curl \
    php-dev \
    php-gd \
    php-imagick \
    php-intl \
    php-json \
    php-mbstring \
    php-memcache \
    php-mysql \
    php-pear \
    php-soap \
    php-xml;

# Install MySQL.
RUN echo "mysql-server mysql-server/root_password password password" | debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password password" | debconf-set-selections && \
    apt-get -yq install mysql-server mysql-client && \
    service mysql start;
EXPOSE 3306

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin;
RUN composer --verbose self-update --stable;

# Install NodeJS, NPM, & Gulp.
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -;
RUN apt-get install -yq nodejs;
RUN npm install -g gulp-cli;

# Clean up installs.
RUN apt-get clean -yq && apt-get autoremove -yq;
RUN rm -rf ~/.composer /tmp/*

CMD bash
