FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="4.12.0-debian-11-r9" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/dreamfactory" \
      org.opencontainers.image.title="dreamfactory" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="4.12.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git gzip jq libaudit1 libbrotli1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libedit2 libexpat1 libffi7 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmd0 libmemcached11 libncurses6 libnettle8 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre2-8-0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.4.30-160" --checksum a9d5c0ad78371d55d1104ac4d1e956f31897f30e26c08ab3ab14f5a4cbf9a6a0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "2.4.54-155" --checksum 28b4021842650460745bdf6985972c6ec32ef2698240ff610ce6a94412b5bfcd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "redis-client" "7.0.4-2" --checksum b2e525476d203f7face934623ec353e5c728b8b941541bfbab34c59c0180525a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "11.17.0-1" --checksum d34624cbd7e1905269ad7d873efe3cad0687bcf52dd822c84ad70c61bca180de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.9-1" --checksum 14ae2f6d8d5f4e3a9e4cf62d5a3da80587a20651a5920dbc4ac89afdaf06f8c0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "libphp" "7.4.30-153" --checksum a3042db70c0790b362497d89b12564a1c29e21a843b10adaa68c318ac0c505b1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-153" --checksum c1f2cdabdcc920512e8936ab2c8a033e1aeb97801fa026f0b12432581bf849ae
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "dreamfactory" "4.12.0-3" --checksum 48e34d183ea185c2b502ff08d2fbc87bba99040b1a8fc4225d366438e2b6662e
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
    APP_VERSION="4.12.0" \
    BITNAMI_APP_NAME="dreamfactory" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/redis/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/dreamfactory/bin:$PATH"

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/dreamfactory/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
