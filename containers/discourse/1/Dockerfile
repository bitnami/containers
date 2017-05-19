FROM bitnami/minideb-extras:jessie-r15
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libc6 libcomerr2 libcurl3 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libxml2 libxml2-dev libxslt1-dev libxslt1.1 sendmail zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.3.4-0 --checksum 92d6db7a6ba0893334e9d1d46a66a7459df08e151762f87942d6b0f29db0171a
RUN bitnami-pkg unpack postgresql-client-9.6.3-0 --checksum fec96be76c0ba5f66a56fbc002b45092abc0100a6d9409d26ddc7391610236de
RUN bitnami-pkg install git-2.10.1-2 --checksum 6f9fd8b0591f268f965930db0c091598e5c4f9dccbb6853010e1ac9e5035cd6f
RUN bitnami-pkg unpack discourse-sidekiq-1.7.8-1 --checksum 970584c2d3c8de27734b9beb4899c4c814968f44971bfd010ef7761092dfdec5
RUN bitnami-pkg unpack discourse-1.7.8-1 --checksum 231f37f7dae593b20a0a24fd316a416fcfc1c1442c2dbed70cb74feb8dd2047b

COPY rootfs /

ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="1.7.8-r3" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_PASSWORD="bitnami" \
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
    POSTGRESQL_PORT="5432" \
    POSTGRESQL_ROOT_PASSWORD="" \
    POSTGRESQL_ROOT_USER="postgres" \
    REDIS_HOST="redis" \
    REDIS_PASSWORD="" \
    REDIS_PORT="6379" \
    SMTP_HOST="" \
    SMTP_PASSWORD="" \
    SMTP_PORT="" \
    SMTP_TLS="true" \
    SMTP_USER=""

VOLUME ["/bitnami/discourse","/bitnami/discourse-sidekiq"]

EXPOSE 3000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","discourse"]
