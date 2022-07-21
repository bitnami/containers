FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates cron curl gzip libaudit1 libbrotli1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libexpat1 libffi7 libfftw3-double3 libfontconfig1 libfreetype6 libgcc-s1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed6 libicu67 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmd0 libmemcached11 libncurses6 libnettle8 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre2-8-0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline8 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "8.0.21-4" --checksum bcb4d971d502982bfeb7c0ce195c6aa2483eeeca054d335df7c438651460546d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "2.4.54-152" --checksum 903fc542776eb549981738f68fdd6435b2c8683686114500f157258dcfdc9617
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.8-151" --checksum c85e4be9bcee70c86c7bc7e13742e2d97810ad8f7d6154f8b66811b6cc4d0948
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "libphp" "8.0.21-1" --checksum f4495e4344887007c7596c92ddca98271a36d6776940db1e55bd43cf159afb01
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "suitecrm" "7.12.6-151" --checksum 71678df5025235184c072bdd0e7f59e78900314cf8332d3d186ebe41c8c8aec3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-151" --checksum 9690a34674f152e55c71a55275265314ed1bb29e0be8a75d7880488509f70deb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron

COPY rootfs /
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
RUN /opt/bitnami/scripts/apache/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/apache-modphp/postunpack.sh
RUN /opt/bitnami/scripts/suitecrm/postunpack.sh
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    APP_VERSION="7.12.6" \
    BITNAMI_APP_NAME="suitecrm" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/suitecrm/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/suitecrm/run.sh" ]
