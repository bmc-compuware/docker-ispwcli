
FROM eclipse-temurin:17-jre-jammy

LABEL author="BMC Software"
USER root

RUN apt-get --no-install-recommends update \
    && apt-get install -y --no-install-recommends unzip git-core wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /workbench-cli
COPY ./dist/TopazCLI-linux.gtk.x86_64.zip /workbench-cli/TopazCLI-linux.gtk.x86_64.zip

WORKDIR "/workbench-cli"
RUN unzip ./TopazCLI-linux.gtk.x86_64.zip
RUN chmod 777 ./SCMDownloaderCLI.sh
RUN rm -rf ./TopazCLI-linux.gtk.x86_64.zip

ENTRYPOINT ["/workbench-cli/SCMDownloaderCLI.sh"]
CMD ["--help"]
