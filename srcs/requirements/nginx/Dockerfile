#base image of container (lightweight linux os)
FROM debian:bullseye

#update = get list of available software versions
#nginx = install nginx web server
#y = automatically answers yes to prompts
#openssl = to generate ssl certificates
#clean + rm = deletes package files + caches from final docker image
RUN apt-get update \
    && apt-get install -y nginx openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#delete the default "welcome to nginx" configuration
#to avoid conflict with custom rules or serve the wrong page
RUN rm -f /etc/nginx/sites-enabled/default && \
    rm -f /etc/nginx/sites-available/default

#copy = replace default server block with our config file
#ln -s = create a symlink (symbolic link) from sites-available to sites-enabled
COPY conf/default.conf /etc/nginx/sites-available/default.conf
RUN ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

#copy = copy setup.sh file from host to container
#chmod = change permissions to executable
#entrypoint = run setup.sh as main process when container starts up
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh
ENTRYPOINT ["/setup.sh"]