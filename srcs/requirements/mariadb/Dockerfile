#base image of container (lightweight linux os)
FROM debian:bullseye

#update = get list of available software versions
#install = install mariadb server
#y = automatically answers yes to prompts
#clean + rm = deletes package files + caches from final docker image
RUN apt-get update \
    && apt-get install -y mariadb-server \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#copy = copy setup.sh file from host to container
#chmod = change permissions to executable
#entrypoint = run setup.sh as main process when container starts up
COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh
ENTRYPOINT ["/setup.sh"]
