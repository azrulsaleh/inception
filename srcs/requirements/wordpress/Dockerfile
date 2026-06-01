#base image of container (lightweight linux os)
FROM debian:bullseye

#php7.4-fpm = installs fastcgi process manager (to process .php files)
#php7.4-mysql = allows php to talk to mariadb database
#mariadb-client = gives container access to mysql cli
#curl = used to download wp-cli and wordpress source code later
#libfcgi-bin = needed to get health check to work (allows docker to speak to fastcgi)
#clean + rm = deletes package files + caches from final docker image
RUN apt-get update \
    && apt-get install -y php7.4-fpm php7.4-mysql mariadb-client curl libfcgi-bin \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#set php-fpm to listen to nginx over port 9000 on the docker network
#mkdir = php-fpm directory to store runtime process id files (.pid)
#sed = stream editor to search and replace text inside files
#i = in-place (modify file directly and save changes immediately
#s|...|...|g = substitution syntax (g = global [replace every instance in file])
RUN mkdir -p /run/php \
    && sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

#install wp-cli
#O = save file on container using the same name as it has on the remote server
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

#download and prepare wordpress source code
#p = parents (create nested folders without throwing an error)
#x = extract files
#z = uncompress using gzip (.tar.gz)
#f = process the file right after this flag (order of flag matters here)
#a = archive (ensure all files keep their original permissions, timestamps and hidden files intact)
#rm = deletes extracted "wordpress" folder and downloaded file
RUN mkdir -p /usr/src/wordpress \
    && curl -O https://wordpress.org/wordpress-6.7.2.tar.gz && tar -xzf wordpress-6.7.2.tar.gz \
    && cp -a wordpress/. /usr/src/wordpress/ && rm -rf wordpress wordpress-6.7.2.tar.gz

#copy = copy setup.sh file from host to container
#chmod = change permissions to executable
#entrypoint = run setup.sh as main process when container starts up
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh
ENTRYPOINT ["/setup.sh"]