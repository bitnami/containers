FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libaudit1 libbrotli1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libedit2 libexpat1 libffi7 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmd0 libmemcached11 libncurses6 libnettle8 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre2-8-0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.4.30-150" --checksum 036d6748844efb2b3809b39c4e5bf0f75fcf167e226297699d72d13583c7bcde
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-150" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "2.4.54-150" --checksum d6ead7637955f94ec4821b1d2ceccb36fb91b8f4ee4aef3bf4287c588be2f1b4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redis-client" "6.0.16-150" --checksum 2c42c7a01f2a56d1ffa7d2269a092871ab80b7f839f72e9f3a38e808996eb4fd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.16.0-150" --checksum 1204401fc614c448f61983e4bc1136b9ba0475c77b2f3ff497ffea59c2879a01
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.8-150" --checksum b47e1015fc1c9ce456f134ffd5b6ac6960c3f369c96fcd37319e9289b29a1047
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "libphp" "7.4.30-150" --checksum eb642c232bfcbf339ac38df9d021ec3ef6da82fdb84e79115ae083ed8326b3dd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.36.1-151" --checksum a7adf946a3e5d1b7e9f18abd4bbf112780a41ea797bdd3f067f87dfea07e85d6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-150" --checksum 8b992a5ee513c5eaca52b19232b21a93588ddf4c4850be4d47c6f19b11d1d90a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "dreamfactory" "4.11.1-150" --checksum 8286cd9b9eeb43feca439f2fe252c0a3eb95689bf5624e2e66961ce0b906ae18
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/apache/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/apache-modphp/postunpack.sh
RUN /opt/bitnami/scripts/dreamfactory/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/php-postgresql/postunpack.sh
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APP_VERSION="4.11.1" \
    BITNAMI_APP_NAME="dreamfactory" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/common/bin:/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/dreamfactory/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/dreamfactory/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
