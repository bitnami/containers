FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages advancecomp ca-certificates curl dirmngr file ghostscript gifsicle gnupg hostname imagemagick jhead jpegoptim libbsd0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant procps rsync sudo unzip zlib1g zlib1g-dev
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install ruby-2.6.5-1 --checksum 99d4bc115bd1f2ce13a76e16359f03acef2ceccfc5468f1b008e9ea9d07dc7fc
RUN bitnami-pkg unpack postgresql-client-11.7.0-0 --checksum 3cd9b46ecb3a60b398e6ed75318f5572619caa143f7d921a7151df3ce7b1727a
RUN bitnami-pkg install git-2.25.1-0 --checksum ca45bb393e1d231affbc8aac5671562af94a92601cc0d7c6b3883fa7bbd20889
RUN bitnami-pkg unpack discourse-sidekiq-2.3.10-0 --checksum f1795069e3a364e8a3804bb44e571a830d8c3dc08f0e10d98287b5f23010f08e
RUN bitnami-pkg install brotli-1.0.7-0 --checksum c5e349954ddf73f15b7a4d732ce594cbfe8b1cd6126c12aed5baf6262127e2be
RUN bitnami-pkg unpack discourse-2.3.10-0 --checksum 01a06b82dc1dc654392a40dde571c4c07ee84bf3a346b6c233f404ffdedbae35
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.3.10-debian-10-r12" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_HOST="discourse" \
    DISCOURSE_HOSTNAME="127.0.0.1" \
    DISCOURSE_PASSENGER_SPAWN_METHOD="direct" \
    DISCOURSE_PASSWORD="bitnami123" \
    DISCOURSE_PORT="3000" \
    DISCOURSE_PORT_NUMBER="3000" \
    DISCOURSE_POSTGRESQL_NAME="bitnami_application" \
    DISCOURSE_POSTGRESQL_PASSWORD="bitnami1" \
    DISCOURSE_POSTGRESQL_USERNAME="bn_discourse" \
    DISCOURSE_SITENAME="My site!" \
    DISCOURSE_SKIP_INSTALL="no" \
    DISCOURSE_USERNAME="user" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_NAME="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME="" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_ROOT_PASSWORD="" \
    POSTGRESQL_ROOT_USER="postgres" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT_NUMBER="6379" \
    SMTP_AUTH="login" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_TLS="yes" \
    SMTP_USER=""

EXPOSE 3000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "discourse" ]
