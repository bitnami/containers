FROM bitnami/minideb-extras:stretch-r494
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages advancecomp file ghostscript gifsicle hostname imagemagick jhead jpegoptim libbsd0 libc6 libcomerr2 libcurl3 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu57 libidn11 libidn2-0 libjpeg-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses5 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libtinfo5 libunistring0 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant rsync zlib1g zlib1g-dev
RUN bitnami-pkg install ruby-2.6.5-0 --checksum 3a856a4569b5d4f59628209a1ab1b78619647bf1f4d5f11ca3ae6b28ee1e7fa9
RUN bitnami-pkg unpack postgresql-client-11.6.0-0 --checksum 84762a54c89698bd4bf9bc380252591492b67464918c291cf2b666e1a74b8f3b
RUN bitnami-pkg install git-2.24.1-0 --checksum 0bd650ac89eff766d64b3d19145ba69873742b8a18815c2957e1fddf86e796ef
RUN bitnami-pkg unpack discourse-sidekiq-2.3.8-0 --checksum a9ec8f4c63ee4a03dbd55c637c8ac8f9aa2a9b6825ebc8d83f99786f7415ca92
RUN bitnami-pkg install brotli-1.0.7-1 --checksum 2ea3eccea57d84390d72467ab2f02e69b06914e1abb9068a308fad1d97d7e247
RUN bitnami-pkg unpack discourse-2.3.8-1 --checksum 212fe46b4e9723e0bce983681a54b4666199cd45773cc737fb96cea33a00bb36
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.3.8-debian-9-r10" \
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
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:$PATH" \
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
