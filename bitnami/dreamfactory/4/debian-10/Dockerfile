FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.4.27-8" --checksum 91191e8bdf140a08f873675198c998fa4fabbea0a22fce0791568b5f8c11aaad
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "2.4.52-2" --checksum 89183ee648d9784108dff25fac2d73a75109bb94cf85a1059c142ebcab23ccbe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redis-client" "6.0.16-3" --checksum dd2b26a8b8dfe89996bf6406e0e0cb4413c7c740792c53e9dd5448ff694cd69b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.14.0-2" --checksum d3359325d864badb385c99ce52a4f4dd1a8a1630f9fb9907ef1545919e0ea058
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.4.22-1" --checksum 37ba718ad68506a9ea0705c12f013a6afc7210c82460769ffba0f16759caae95
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "libphp" "7.4.27-3" --checksum aa7b45645b0395875b7281b74885a2a36c4d87dc19de87c7ed8b529df8e003a0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.34.1-2" --checksum c6f5511335c6ea2e98cb02cefc77a67aae6e570a0a15229ab620414d0278525a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-5" --checksum 9e312b4a7e16a55d08e67c4fd69c91000e4dcc4af149d59915c49375b83852af
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "dreamfactory" "4.10.1-0" --checksum 8833df2e11b51a20882a1b90f644eeaec38a149c66d3d3e5b7281173247a18c5
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/apache/postunpack.sh
RUN /opt/bitnami/scripts/apache-modphp/postunpack.sh
RUN /opt/bitnami/scripts/dreamfactory/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/php-postgresql/postunpack.sh
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    BITNAMI_APP_NAME="dreamfactory" \
    BITNAMI_IMAGE_VERSION="4.10.1-debian-10-r0" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:/opt/bitnami/dreamfactory/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/dreamfactory/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
