FROM bitnami/minideb-extras:stretch-r366
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages advancecomp file ghostscript gifsicle hostname imagemagick jhead jpegoptim libbsd0 libc6 libcomerr2 libcurl3 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant rsync zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.5.5-0 --checksum 7f676dbe187bb037fed4fd25da35ac68b34621e629ea5b80ee82afbccfbe9c6f
RUN bitnami-pkg unpack postgresql-client-11.3.0-0 --checksum eb5e96b4b53e9f60dc07d5f9823d09f7884aa9c2408da5bec92beb6cbf6a9de4
RUN bitnami-pkg install git-2.21.0-0 --checksum 37eb00d863f94194c0c31464c2c747bc784e662adbab240b5f0ef46b3e259e52
RUN bitnami-pkg unpack discourse-sidekiq-2.2.5-2 --checksum 5f1620ded974bca6a0d44bbca2221abb97db513c267b8dd382f25155697dc2cb
RUN bitnami-pkg unpack discourse-2.2.5-1 --checksum a6a5678a6795040d7322b700979b0266bd4bdcaf6fdd21ce234ebfee64aae2df
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.2.5-debian-9-r1" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_EXTERNAL_PORT_NUMBER="80" \
    DISCOURSE_HOST="discourse" \
    DISCOURSE_HOSTNAME="127.0.0.1" \
    DISCOURSE_PASSWORD="bitnami123" \
    DISCOURSE_PORT="3000" \
    DISCOURSE_PORT_NUMBER="3000" \
    DISCOURSE_POSTGRESQL_NAME="bitnami_application" \
    DISCOURSE_POSTGRESQL_PASSWORD="bitnami1" \
    DISCOURSE_POSTGRESQL_USERNAME="bn_discourse" \
    DISCOURSE_SITENAME="My site!" \
    DISCOURSE_USERNAME="user" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:$PATH" \
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
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_TLS="true" \
    SMTP_USER=""

EXPOSE 3000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "discourse" ]
