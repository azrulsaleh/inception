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

#generate the ssl certificate (self-signed)
#x509 = create a self-signed certificate (rather than a certificate signing request [csr])
#nodes = "no des" (private key won't be encrypted with password - nginx starts up without prompt for password)
#days 365 = cert valid for 1 year
#newkey = create certificate and RSA 2048 private key simultaneously
#keyout = where private key is stored
#out = where certificate is stored
#subj = fill out certificate identity fields (country, state, organization, common name)
RUN mkdir -p /etc/nginx/ssl \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=MY/ST=Kuala Lumpur/L=Kuala Lumpur/O=42/OU=Inception/CN=azsaleh.42.fr"

#delete the default "welcome to nginx" configuration
#to avoid conflict with custom rules or serve the wrong page
RUN rm -f /etc/nginx/sites-enabled/default && \
    rm -f /etc/nginx/sites-available/default

#copy = replace default server block with our config file
#ln -s = create a symlink (symbolic link) from sites-available to sites-enabled
COPY conf/default.conf /etc/nginx/sites-available/default.conf
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

#run nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]