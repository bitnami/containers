FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG EXTRA_LOCALES=""
ARG WITH_ALL_LOCALES="no"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates cron curl gzip libaudit1 libbsd0 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcurl4 libedit2 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjemalloc2 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmcrypt4 libmemcached11 libmemcachedutil2 libncurses6 libnettle6 libnghttp2-14 libonig5 libp11-kit0 libpam0g libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 locales procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "7.4.27-11" --checksum 6058fe96e8d9e8c40156a0a054318ec21ed9992bd7865f72e641e18dff5d26ac
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "2.4.52-4" --checksum 4705387b2f4ef926d0bde06738df29db4abd61583cedc83d238b8b7e10e3f6b8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "postgresql-client" "13.6.0-1" --checksum 7677c5c3187f00595393dfcbab89de5626d08cafd9888c19a5ef74ce6c361630
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.32-31" --checksum 4489feca3a65fbd733774d193b02914187451c6edf27855ebc5756e45a9f299e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "libphp" "7.4.27-6" --checksum bff2748eb1fb7b9ebcd40a5b660985e17cdccecb0acda003a453d84de99c61bc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-7" --checksum ed811d10882450d4755b893d5e034a0dd912cdb4f261dd332ddf6363411cc0ba
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "moodle" "3.11.5-3" --checksum d512c1ac24d84e4628b579f6b2591749fd02d136b6c10eba752f08df40efcd64
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN localedef -c -f UTF-8 -i en_US en_US.UTF-8
RUN sed -i -e '/pam_loginuid.so/ s/^#*/#/' /etc/pam.d/cron
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales
RUN echo 'en_AU.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen
RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen

COPY rootfs /
RUN /opt/bitnami/scripts/locales/add-extra-locales.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
RUN /opt/bitnami/scripts/apache/postunpack.sh
RUN /opt/bitnami/scripts/apache-modphp/postunpack.sh
RUN /opt/bitnami/scripts/moodle/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    BITNAMI_APP_NAME="moodle" \
    BITNAMI_IMAGE_VERSION="3.11.5-debian-10-r29" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/apache/bin:/opt/bitnami/postgresql/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

USER root
ENTRYPOINT [ "/opt/bitnami/scripts/moodle/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/moodle/run.sh" ]
