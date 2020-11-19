FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages advancecomp ca-certificates curl file ghostscript gifsicle gzip hostname imagemagick jhead jpegoptim libbsd0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant procps rsync sqlite3 sudo tar zlib1g zlib1g-dev
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install ruby-2.6.6-1 --checksum bffb82ccf296b8fcd3a28255ac372a6234efbcd57a2a2f9b9fa924724038abdb
RUN bitnami-pkg unpack postgresql-client-11.10.0-0 --checksum ad9f4e750583d0f7b02afc119c3b505fc780c0c13407983a96f2923dc7e33c3e
RUN bitnami-pkg install git-2.29.2-0 --checksum aebe650c294f00bacd383f90db2bbf5033dc32acc500d39fa66367f0118b7c9d
RUN bitnami-pkg unpack discourse-sidekiq-2.5.4-0 --checksum 6ca30aa31a46bbf4a8982b17309aebd1f8282128443212fb039b337b1e027379
RUN bitnami-pkg install brotli-1.0.9-0 --checksum 710dd6f5c97af313d0e867e793bedc013aebe173f9c28d0fabc09a16d3100ab6
RUN bitnami-pkg install tini-0.19.0-1 --checksum 9b1f1c095944bac88a62c1b63f3bff1bb123aa7ccd371c908c0e5b41cec2528d
RUN bitnami-pkg install gosu-1.12.0-2 --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN bitnami-pkg unpack discourse-2.5.4-0 --checksum 140fb5a572a5ab064bcdbcc6d0fe64d5018cdee49c02a4438af5c2340fd75f80
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.5.4-debian-10-r18" \
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
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
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
