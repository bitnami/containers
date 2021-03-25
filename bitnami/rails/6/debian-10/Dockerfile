FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl build-essential ca-certificates curl default-libmysqlclient-dev ghostscript git gzip imagemagick libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libsqlite3-dev libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2 libxml2-dev libxslt1-dev netcat netcat-traditional pkg-config procps sqlite3 sudo tar unzip wget zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.6-2" --checksum 4a1c68af2b652fd873124ebb00ec79574007105730059539b1d3223bbea2af34
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.16.0-0" --checksum 969129b158e7c651dad4afe5eb8a549cd05d8ec0bbd77cf362f0f183d1d33910
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.28-0" --checksum 9398376ca9e2033d5bc193232e8aa9b57d91d4ccf06fa67bfa0d30ef36e44c25
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.31.0-1" --checksum 0dd2867ac19a1be539a8c40f9b1290d0a53a19d7dfe3a0ca5ee57ff795d89b4a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rails" "6.1.3-0-0" --checksum 7e69d6db999786e58db00a7393db0e07c65c3dd2069fd732bcce4c965b667708
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/rails/postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.1.3-0-debian-10-r33" \
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
