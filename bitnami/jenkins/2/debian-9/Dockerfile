FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/java/bin:/opt/bitnami/git/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl dirmngr fontconfig fonts-dejavu-extra gnupg libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libtasn1-6 libunistring0 openssh-client procps sudo unzip zlib1g
RUN /bitnami-user.sh && \
    /install-nami.sh
RUN bitnami-pkg install java-1.8.232-0 --checksum f4e5ff1d4fb13baf9bb2a4f2e5ffb328cf9eeb26d0b91214196e4473c2874adc
RUN bitnami-pkg install git-2.25.0-0 --checksum 49b040c04ed41e5707e3aac4bbc13553a865dc16acd2053e50e4355d13a373d1
RUN bitnami-pkg unpack jenkins-2.204.1-0 --checksum 5542890a7b910ced971077b1f50bac83f60653c4b86a747ed27d69f8b02a3f04
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
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
RUN mkdir -p /usr/share/jenkins/ref

COPY rootfs /
RUN ln -sf /install-plugins.sh /usr/local/bin/install-plugins.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.204.1-debian-9-r2" \
    DISABLE_JENKINS_INITIALIZATION="no" \
    JAVA_OPTS="" \
    JENKINS_HOME="/opt/bitnami/jenkins/jenkins_home" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user"

EXPOSE 8080 8443 50000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
