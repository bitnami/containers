FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/rails/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages build-essential ca-certificates curl default-libmysqlclient-dev dirmngr ghostscript gnupg imagemagick libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2-dev libxslt1-dev netcat-traditional procps sudo unzip zlib1g zlib1g-dev
RUN /bitnami-user.sh && \
    /install-nami.sh
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 3a856a4569b5d4f59628209a1ab1b78619647bf1f4d5f11ca3ae6b28ee1e7fa9
RUN bitnami-pkg install node-10.18.1-0 --checksum ea470130eeb8730473153d75bcdd8979032120fcad9aae7fc6730615b76d888c
RUN bitnami-pkg install mysql-client-10.3.21-0 --checksum 19c6b964f289772a4e5963e22929133fa65222f66752eb29af715ce3d0b7ef0e
RUN bitnami-pkg install git-2.25.0-0 --checksum 49b040c04ed41e5707e3aac4bbc13553a865dc16acd2053e50e4355d13a373d1
RUN bitnami-pkg install rails-6.0.2-1-1 --checksum 5907cdc43f4d3a30e1141db8b4e92259d4824548771f6d044830591694c1cde2
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /app && chown bitnami:bitnami /app
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
ENV BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.2-1-debian-9-r22" \
    BUNDLE_BUILD__SASSC="--disable-march-tune-native" \
    RAILS_ENV="development"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
