FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr gnupg libc6 libgcc1 lsof procps sudo unzip zlib1g
RUN curl --silent -L https://nami-prod.s3.amazonaws.com/tools/nami/releases/nami-1.0.0-1-linux-x64.tar.gz > /tmp/nami-linux-x64.tar.gz && \
    echo "80488279b056d5e9c183fe34097c5f496715ab16a602afcc9f78d59f15139a16 /tmp/nami-linux-x64.tar.gz" | sha256sum --check && \
    mkdir -p /opt/bitnami/nami /opt/bitnami/licenses && \
    tar xzf /tmp/nami-linux-x64.tar.gz --strip 1 -C /opt/bitnami/nami && \
    rm /tmp/nami-linux-x64.tar.gz && \
    curl --silent -L https://raw.githubusercontent.com/bitnami/nami/master/COPYING > /opt/bitnami/licenses/nami-1.0.0-1.txt
RUN bitnami-pkg install java-1.8.232-0 --checksum f4e5ff1d4fb13baf9bb2a4f2e5ffb328cf9eeb26d0b91214196e4473c2874adc
RUN bitnami-pkg unpack solr-8.4.1-0 --checksum de3e8461cf6c4d8eae4f7584cc69c850126efe966077fc2de65677d9e6d40bd0
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -ms /bin/bash bitnami && \
    mkdir -p /opt/bitnami && chown bitnami:bitnami /opt/bitnami && \
    sed -i -e 's/\s*Defaults\s*secure_path\s*=/# Defaults secure_path=/' /etc/sudoers && \
    echo 'bitnami ALL=NOPASSWD: ALL' >> /etc/sudoers
RUN curl --silent -L https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    echo 0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7 /usr/local/bin/gosu | sha256sum --check && \
    chmod u+x /usr/local/bin/gosu && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/tianon/gosu/master/LICENSE > /opt/bitnami/licenses/gosu-1.11.txt
RUN for server in "ha.pool.sks-keyservers.net" "hkp://p80.pool.sks-keyservers.net:80" "keyserver.ubuntu.com" "hkp://keyserver.ubuntu.com:80" "pgp.mit.edu"; do gpg --keyserver $server --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 && break || : ; done && \
    gpg --fingerprint 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7 | grep -q "6380 DC42 8747 F6C3 93FE  ACA5 9A84 159D 7001 A4E5" && \
    curl --silent -L https://github.com/krallin/tini/releases/download/v0.13.2/tini.asc > /tmp/tini.asc && \
    curl --silent -L https://github.com/krallin/tini/releases/download/v0.13.2/tini > /usr/local/bin/tini && \
    gpg --verify /tmp/tini.asc /usr/local/bin/tini && \
    chmod +x /usr/local/bin/tini && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/krallin/tini/master/LICENSE > /opt/bitnami/licenses/tini-0.13.2.txt

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.4.1-debian-9-r1" \
    NAMI_PREFIX="/.nami" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
