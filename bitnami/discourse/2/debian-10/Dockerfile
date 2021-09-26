FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl advancecomp ca-certificates curl file ghostscript gifsicle gzip hostname imagemagick jhead jpegoptim libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg-turbo-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant procps rsync sqlite3 tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-2" --checksum e00677f5209d9426daff2db54cf00e04c46718bbdbc0717aee07e6a727ef05ad
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-3" --checksum 7521d9a4f9e4e182bf32977e234026caa7b03759799868335bccb1edd8f8fd12
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "uglify-js" "3.14.2-0" --checksum 9a13413877669f8aed9936297a2240da5ff422085bba5b78cf28ff95cd78bde8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.4-1" --checksum c0f9bcb452ea0833b81159c1e1656ab0174131930157659875309be2fed2d57c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.4.0-0" --checksum 6c426cd27401d66914b19e8d647a5d1bda1f8cd632836aa2b8ce705c2d643e99
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.17.6-0" --checksum 2c35e2baaa990e10d6cd5083530dbfa1f16075788eacbe4382d8b08abdbc8460
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.33.0-0" --checksum fd9a3245580fef6248f778efeba0a017675424f15ff16ace42c095496e4f02f3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "brotli" "1.0.9-0" --checksum 710dd6f5c97af313d0e867e793bedc013aebe173f9c28d0fabc09a16d3100ab6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "discourse" "2.7.8-0" --checksum eaccd4829a67ad41c719598f9c4bbe4317ae4eb27084138eb4fdea0b408c7628
RUN chmod g+rwX /opt/bitnami
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
RUN /opt/bitnami/scripts/discourse/postunpack.sh
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.7.8-debian-10-r20" \
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
