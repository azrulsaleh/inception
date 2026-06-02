FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y nginx openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN rm -f /etc/nginx/sites-enabled/default && \
    rm -f /etc/nginx/sites-available/default

COPY conf/default.conf /etc/nginx/sites-available/default.conf
RUN ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh
ENTRYPOINT ["/setup.sh"]