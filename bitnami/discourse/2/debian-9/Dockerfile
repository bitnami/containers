FROM bitnami/minideb-extras:stretch-r91
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ghostscript imagemagick libbsd0 libc6 libcomerr2 libcurl3 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2 libxml2-dev libxslt1-dev libxslt1.1 sendmail zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.4.4-0 --checksum 8ffc50475a39ffe9f3048a64df2e20e1867ece8ba90d8e96c8a81a3a06334f5f
RUN bitnami-pkg unpack postgresql-client-9.6.9-1 --checksum ad587c6b5c21b2f668e127d69551b0982bdb88745b50d514da9cab55a9855474
RUN bitnami-pkg install git-2.18.0-1 --checksum acf77a7b174b2b4201335fc400a4fa32dbdca237d18fa90a5fa76f4fd3008517
RUN bitnami-pkg unpack discourse-sidekiq-2.0.2-0 --checksum df308404f1e6ba3e811752e77a97a3b803590f431b24e88fa6dafe8abf76d037
RUN bitnami-pkg unpack discourse-2.0.3-0 --checksum e6725918bcf974c9dcf469dea1b17564e6dbff7bdc7fdda7084fafc74e685044

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.0.3-debian-9-r3" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_HOST="127.0.0.1" \
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

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","discourse"]
