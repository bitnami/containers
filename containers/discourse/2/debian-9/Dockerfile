FROM bitnami/minideb-extras:stretch-r277
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages advancecomp ghostscript gifsicle hostname imagemagick jhead jpegoptim libbsd0 libc6 libcomerr2 libcurl3 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.4.5-20 --checksum f1496dcc6b4fce4c661c6af478ac989cbc9717f96fc916499a78b9cf8e7fb3d2
RUN bitnami-pkg unpack postgresql-client-9.6.11-20 --checksum 2bc216764c4a64282521a6db63da61eeaa9f35c7f0670cba171c9de889bbc819
RUN bitnami-pkg install git-2.20.1-20 --checksum eeb8a6101929fc294dcead9e97938af819d45eff53ca5f531285de4686f4151f
RUN bitnami-pkg unpack discourse-sidekiq-2.2.0-0 --checksum 9ab26b793d24e2ec1370ad99db495be52c31a83dffb40cdced6ea2d43f9e0d81
RUN bitnami-pkg unpack discourse-2.1.8-0 --checksum 4a5bac4c2cd608c0110b118d0adc44a644dd6e8dae1fa64213d3238a9cf0cddb

COPY rootfs /
RUN install_packages rsync
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.1.8-debian-9-r13" \
    DISCOURSE_EMAIL="user@example.com" \
    DISCOURSE_EXTERNAL_PORT_NUMBER="80" \
    DISCOURSE_HOST="127.0.0.1" \
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
