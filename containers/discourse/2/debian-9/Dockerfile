FROM bitnami/minideb-extras:stretch-r170
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages advancecomp gifsicle hostname imagemagick jhead jpegoptim libbsd0 libc6 libcomerr2 libcurl3 libedit2 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2 libxslt1.1 optipng pngcrush pngquant zlib1g
RUN bitnami-pkg install ruby-2.4.4-2 --checksum c30a70f04c4e4cf9c785e1c9a5144f80afea64995d8d236951f493640beffefd
RUN bitnami-pkg unpack postgresql-client-9.6.10-1 --checksum 183670e5d3c1186ad98309216cb79c01187b7e71e0d2dae5121d41ff998313f5
RUN bitnami-pkg install git-2.19.1-1 --checksum 0ea45e1d5975f3cefe6e992079206e86ec66e1481b46f2c8d302ef57d2dc7397
RUN bitnami-pkg unpack discourse-sidekiq-2.1.2-0 --checksum 6f163109dceb7bf307f937eae40f5300dae5cde851899711e9e3ee0e7a896ac8
RUN bitnami-pkg unpack discourse-2.1.2-1 --checksum 853ec09b76bb94b39079236c195e34015eb0b2bb32959d47ebed17309bc26854

COPY rootfs /
RUN install_packages rsync
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.1.2-debian-9-r6" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_HOST="127.0.0.1" \
    DISCOURSE_HOSTNAME="www.example.com" \
    DISCOURSE_PASSWORD="bitnami123" \
    DISCOURSE_PORT="3000" \
    DISCOURSE_POSTGRESQL_NAME="bitnami_application" \
    DISCOURSE_POSTGRESQL_PASSWORD="bitnami1" \
    DISCOURSE_POSTGRESQL_USERNAME="bn_discourse" \
    DISCOURSE_SITE_NAME="My site!" \
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
