
FROM adoptopenjdk/openjdk11:jre-11.0.10_9

LABEL author="Compuware - A BMC Company"
USER root

RUN apt-get --no-install-recommends update \
    && apt-get install -y --no-install-recommends unzip git \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /TopazCliInstall
COPY SyncToIspw.sh /TopazCliInstall/SyncToIspw.sh	
COPY dist/TopazCLI-linux.gtk.x86_64.zip /TopazCliInstall/TopazCLI-linux.gtk.x86_64.zip

WORKDIR "/TopazCliInstall"
RUN unzip TopazCLI-linux.gtk.x86_64.zip
RUN chmod 777 IspwCLI.sh SyncToIspw.sh
RUN rm -rf ./TopazCLI-linux.gtk.x86_64.zip

ENTRYPOINT ["/TopazCliInstall/SyncToIspw.sh"]
CMD ["SyncToIspw"]
