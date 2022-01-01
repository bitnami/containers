FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl advancecomp ca-certificates curl file ghostscript gifsicle gzip hostname imagemagick jhead jpegoptim libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg-turbo-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant procps rsync sqlite3 tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-10" --checksum ff93eb9ba98c14c9eea2ac0a6601c7b17306214936ba4f9589745976059b6bcb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-4" --checksum 53c0f1a5361a68c298f31f6701c8e8a026e77f09805d54ecfeb52cf5998d7d06
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "uglify-js" "3.14.5-0" --checksum ace5c00c36764e3c0d24005bd4c6db24a0ee61f8a6dab315655346571331ee45
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.5-1" --checksum 52bce7e8597d553ded3502f8c8240a68cae74d1b949f6cd65a0f9bcbecce17f7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.5.0-0" --checksum eb9051af5a9077ff41349b271ffd1029af7088bcf3d1f5ac81c2c6707801fbec
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.18.2-0" --checksum 5753bbbe5052000888c24ef8c918cfc45577878b03cc4dcfe7d53ea562a48e5a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.34.1-0" --checksum 3da2501870c9c3efe8cfa47b7bba894d8d97292a5274b682af1eded3b671641b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "brotli" "1.0.9-0" --checksum 710dd6f5c97af313d0e867e793bedc013aebe173f9c28d0fabc09a16d3100ab6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "discourse" "2.7.12-1" --checksum adb3c86942c050dc5a0ac9938d7012aa037623421e6bd8080b22eaf1105dfde7
RUN chmod g+rwX /opt/bitnami
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
RUN /opt/bitnami/scripts/discourse/postunpack.sh
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.7.12-debian-10-r9" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:$PATH" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_NAME="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME="" \
    POSTGRESQL_HOST="postgresql" \
    POSTGRESQL_PORT_NUMBER="5432" \
    POSTGRESQL_ROOT_PASSWORD="" \
    POSTGRESQL_ROOT_USER="postgres"

EXPOSE 3000

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/discourse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/discourse/run.sh" ]
