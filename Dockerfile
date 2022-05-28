FROM ubuntu:focal
LABEL Author="boozaa" Description="Ubuntu Focal - Apache2 + PHP 8.1 + modules + composer"

# Stop dpkg-reconfigure tzdata from prompting for input
ENV DEBIAN_FRONTEND=noninteractive

# Configure timezone
RUN echo "Europe/Paris" > /etc/timezone
RUN mkdir -p /var/www/html/public/

RUN apt-get update
RUN apt-get -y install software-properties-common && add-apt-repository ppa:ondrej/php -y
RUN apt-get update
RUN apt-get upgrade -y


# Les paquets utiles
RUN apt-get -y install \
        nano \
        tree \
        zip \
        unzip \
        curl \
        wget \
        git \
        gnupg

# Apache2
RUN apt-get -y install apache2 php8.1 libapache2-mod-php8.1

# PHP7.4 et extensions
RUN apt-get -y install \
        php8.1-cli \
        php8.1-curl \
        php8.1-mbstring \
        php8.1-gd \
        php8.1-mysql \
        #php8.1-json \
        php8.1-ldap \
        #php8.1-mime-type \
        php8.1-pgsql \
        php8.1-tidy \
        php8.1-intl \
        php8.1-xmlrpc \
        php8.1-soap \
        php8.1-uploadprogress \
        php8.1-zip \
        php8.1-sqlite3 \
        php8.1-xml \
        php8.1-opcache    

# Site / Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get -y install libcap2-bin && \
    setcap 'cap_net_bind_service=+ep' /usr/sbin/apache2 && \
    apt-get -y autoremove && \
    a2disconf other-vhosts-access-log && \
    chown -Rh www-data. /var/run/apache2

RUN a2disconf other-vhosts-access-log && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Apache
#COPY conf/vhost.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite headers expires ext_filter remoteip

EXPOSE 80
USER root

ENTRYPOINT ["apache2ctl", "-D", "FOREGROUND"]