FROM php:8.3-fpm

WORKDIR /var/www

RUN apt-get update && \
    apt-get install -y \
        libzip-dev \
        zip \
        build-essential \
        libpng-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        locales \
        jpegoptim optipng pngquant gifsicle \
        vim \
        unzip \
        git \
        curl

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install zip

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd \

RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin \
    --filename=composer

RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

COPY ./app/* /var/www

COPY --chown=www:www ./app/* /var/www
RUN chown -R www-data:www-data /var/www

USER www

EXPOSE 9000

CMD ["php-fpm"]
