FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl build-essential ca-certificates curl default-libmysqlclient-dev ghostscript git gzip imagemagick libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libsqlite3-dev libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2 libxml2-dev libxslt1-dev netcat netcat-traditional pkg-config procps sqlite3 sudo tar unzip wget zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.7-0" --checksum 3d605c181d6ae44f6a6debb7c89a4dc64081b5ee28ca41354946f1fa5cd1276a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.17.0-0" --checksum 445d6ffbde4c69c382f1d1614f014fb29c716756e6e91e9d5792bfb5268ea4d1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.29-0" --checksum 5bf8f1ed022c8ad75a4db5b8b72ae54ce427bff628d7e4025c5b5e67b876708d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.32.0-0" --checksum 3094f50c904e966bd6c6a2d6152cf41fd3a816d32395622a785ccbcda62b7c5f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rails" "6.1.3-2-0" --checksum 7df502beb3c2541686d3f87e412b79956e1fb0716e05ba37889a43d84ada7188
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/rails/postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.1.3-2-debian-10-r17" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="" \
    MARIADB_ROOT_USER="root" \
    MYSQL_CLIENT_CREATE_DATABASE_NAME="" \
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="" \
    MYSQL_CLIENT_CREATE_DATABASE_PRIVILEGES="ALL" \
    MYSQL_CLIENT_CREATE_DATABASE_USER="" \
    MYSQL_CLIENT_ENABLE_SSL="no" \
    MYSQL_CLIENT_SSL_CA_FILE="" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/node/bin:/opt/bitnami/python/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER bitnami
ENTRYPOINT [ "/opt/bitnami/scripts/rails/entrypoint.sh" ]
CMD [ "bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000" ]
