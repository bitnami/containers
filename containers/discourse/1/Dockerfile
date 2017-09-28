FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libc6 libcomerr2 libcurl3 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmysqlclient18 libncurses5 libnettle4 libp11-kit0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libtinfo5 libxml2 libxml2-dev libxslt1-dev libxslt1.1 sendmail zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.3.4-1 --checksum ea18a43840fdff9d113f7b3c6f4b6ec10abd88f1b84d65cda0bb61020dfdbb64
RUN bitnami-pkg unpack postgresql-client-9.6.5-0 --checksum 96fe70bda6f0a296dcb594cd28b6810a03c6b4ba82c1ae13a228bda20cb4c423
RUN bitnami-pkg install git-2.14.2-0 --checksum 3fa698364678e696e0b580cd7e9979a453ad5c590c373dbe5217cdcbd3666ec9
RUN bitnami-pkg unpack discourse-sidekiq-1.8.7-0 --checksum ef0b8dd5da110af3a96a3576280c2ef580a54d907cc95b5728f661d4bd503287
RUN bitnami-pkg unpack discourse-1.8.8-0 --checksum abdd79ebb22ea950521445b7cca8bddc8d541be5bbf3fc898d94ed49741d783c

COPY rootfs /

ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="1.8.8-r0" \
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

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","discourse"]
