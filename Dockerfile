FROM php:5.6-apache

ARG branch=master

RUN apt-get update && \
  
    apt-get install -y \
        sendmail \
        git \
        zip \
        unzip && \

    # PHP extensions
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        zlib1g-dev libicu-dev g++ \
        php5-mysqlnd && \

        docker-php-ext-install -j$(nproc) iconv mcrypt zip && \

        docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
        docker-php-ext-install -j$(nproc) gd && \

        docker-php-ext-install mysqli mysql pdo pdo_mysql && \

        docker-php-ext-configure intl && \
        docker-php-ext-install intl && \

        # Framadate
        git clone https://github.com/framasoft/framadate.git ./ && \
        git checkout ${branch} && \
        curl https://getcomposer.org/installer | php -- --quiet && \
        php composer.phar install && \
        mkdir tpl_c && \
        chown -R www-data:www-data . && \

        # Clean
        apt-get autoremove -y --purge git && \

        # Enable htaccess for fancy URLs
        mv htaccess.txt .htaccess

# Configuration
COPY --chown=www-data:www-data php.ini ./php.ini

# Links for docker logs
RUN ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log && \
    ln -sf /proc/self/fd/1 ./admin/stdout.log
