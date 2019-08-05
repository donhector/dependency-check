FROM openjdk:8-jre-slim

MAINTAINER https://github.com/donhector

ENV version_url=https://jeremylong.github.io/DependencyCheck/current.txt
ENV download_url=https://dl.bintray.com/jeremy-long/owasp

ENV GOSU_URL=https://github.com/tianon/gosu/releases/download/1.11/gosu

COPY entrypoint.sh /usr/local/bin/entrypoint.sh


RUN apt-get update                                                            && \
    apt-get install -y --no-install-recommends unzip wget ruby mono-runtime   && \
    gem install bundle-audit                                                  && \
    gem cleanup                                                               && \
    wget -O /tmp/current.txt ${version_url}                                   && \
    version=$(cat /tmp/current.txt)                                           && \
    file="dependency-check-${version}-release.zip"                            && \
    wget "$download_url/$file"                                                && \
    unzip ${file}                                                             && \
    rm ${file}                                                                && \
    mv dependency-check /usr/share/                                           && \
    mkdir /report                                                             && \
    wget -O /usr/local/bin/gosu "$GOSU_URL-$(dpkg --print-architecture)"      && \
    chmod +x /usr/local/bin/gosu                                              && \
    chmod +x /usr/local/bin/entrypoint.sh                                     && \
    apt-get remove --purge -y wget unzip                                      && \
    apt-get autoremove -y                                                     && \
    rm -rf /var/lib/apt/lists/* /tmp/*

VOLUME ["/src" "/usr/share/dependency-check/data" "/report"]

WORKDIR /src

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
