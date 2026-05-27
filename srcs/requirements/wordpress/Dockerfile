FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y php8.2-fpm php8.2-mysql curl mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' \
    /etc/php/8.2/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /usr/src/wordpress && \
    curl -O https://wordpress.org/wordpress-6.7.2.tar.gz && \
    tar -xzf wordpress-6.7.2.tar.gz && \
    cp -a wordpress/. /usr/src/wordpress/ && \
    rm -rf wordpress wordpress-6.7.2.tar.gz

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

ENTRYPOINT ["/setup.sh"]