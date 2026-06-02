FROM debian:bullseye

RUN apt-get update \
    && apt-get install -y mariadb-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh
ENTRYPOINT ["/setup.sh"]
