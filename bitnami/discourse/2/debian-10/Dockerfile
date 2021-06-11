FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl advancecomp ca-certificates curl file ghostscript gifsicle gzip hostname imagemagick jhead jpegoptim libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libedit2 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg-turbo-progs libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libuuid1 libxml2 libxml2-dev libxslt1-dev libxslt1.1 optipng pngcrush pngquant procps rsync sqlite3 tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-3" --checksum 7521d9a4f9e4e182bf32977e234026caa7b03759799868335bccb1edd8f8fd12
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "uglify-js" "3.13.9-0" --checksum 0633e9c43248da7ae3ea786c0c4d5d51a2610700dda104f8f8bad1eea9f893d6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.7.3-0" --checksum 2d90de24a8b55a41379330d94c075beefed4f657de5edbb6d89c350b7e1b69aa
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.3.0-0" --checksum 1202c736e3c5b28de1dd1deb05eb2d68bd7ebccc54c9ed1eab05220f346456c3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.17.0-0" --checksum 445d6ffbde4c69c382f1d1614f014fb29c716756e6e91e9d5792bfb5268ea4d1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.32.0-0" --checksum 3094f50c904e966bd6c6a2d6152cf41fd3a816d32395622a785ccbcda62b7c5f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "brotli" "1.0.9-0" --checksum 710dd6f5c97af313d0e867e793bedc013aebe173f9c28d0fabc09a16d3100ab6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "discourse" "2.7.1-0" --checksum 5e2ed95b410b123aad34a37ab999b863bd302fa8ed3e482e14ba9e4cbbf4c70e
RUN chmod g+rwX /opt/bitnami
RUN /opt/bitnami/ruby/bin/gem install --force bundler -v '< 2'

COPY rootfs /
RUN /opt/bitnami/scripts/discourse/postunpack.sh
ENV BITNAMI_APP_NAME="discourse" \
    BITNAMI_IMAGE_VERSION="2.7.1-debian-10-r0" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/ruby/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/node/bin:/opt/bitnami/python/bin:/opt/bitnami/git/bin:/opt/bitnami/brotli/bin:$PATH" \
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
