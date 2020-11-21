FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl build-essential ca-certificates curl default-libmysqlclient-dev ghostscript git gzip imagemagick libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp-dev libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libmariadb3 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libp11-kit0 libpam0g libpq5 libpsl5 libreadline-dev libreadline7 librtmp1 libsasl2-2 libsqlite3-0 libsqlite3-dev libssh2-1 libssl-dev libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libunistring2 libxml2 libxml2-dev libxslt1-dev netcat netcat-traditional pkg-config procps sqlite3 sudo tar unzip wget zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.6-1" --checksum bffb82ccf296b8fcd3a28255ac372a6234efbcd57a2a2f9b9fa924724038abdb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "10.23.0-0" --checksum 7fd7b745562af8259a10e8160fb01e54acb6c92f945b05f1c97018ea61eed173
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.27-0" --checksum f96905e763a6334b75a7cdb07f8d89658cde02be41cb09d91d0682fc649fdcff
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.29.2-0" --checksum aebe650c294f00bacd383f90db2bbf5033dc32acc500d39fa66367f0118b7c9d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "rails" "6.0.3-4-0" --checksum fb598415ed18c445807aa9c6d84271ea648c6aee4b4d3d229ea28a6c85867f26
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/rails/postunpack.sh
ENV ALLOW_EMPTY_PASSWORD="no" \
    BITNAMI_APP_NAME="rails" \
    BITNAMI_IMAGE_VERSION="6.0.3-4-debian-10-r35" \
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
