FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbsd0 libbz2-1.0 libc6 libcom-err2 libcurl4 libexpat1 libffi6 libfftw3-double3 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgomp1 libgpg-error0 libgssapi-krb5-2 libhogweed4 libicu63 libidn2-0 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblcms2-2 libldap-2.4-2 liblqr-1-0 libltdl7 liblzma5 libmagickcore-6.q16-6 libmagickwand-6.q16-6 libmemcached11 libmemcachedutil2 libncurses6 libncursesw6 libnettle6 libnghttp2-14 libonig5 libp11-kit0 libpcre3 libpng16-16 libpq5 libpsl5 libreadline7 librtmp1 libsasl2-2 libsodium23 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libsybdb5 libtasn1-6 libtidy5deb1 libtinfo6 libunistring2 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 libxslt1.1 libzip4 procps sqlite3 sudo tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-3" --checksum a328c8fb3db9e60d3aa19eb7ca31de5da372affcb3d7c0d73610b4a19b634f94
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "php" "8.1.6-0" --checksum 5a54f59880dd5071417843344c77792edfe1bddbd6768520eb00a19aa26cc771
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.3-0" --checksum 1f82279c7a88cfa1a1bf03e8d10064a00dba5b7b21923c0dd7cbca7e712a6aa3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-0" --checksum 0603c8eaf6d24e76563431e36e512da06bfebb3a06ede31b3e84d9879213c162
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "laravel" "9.1.8-0" --checksum d25f646866d652de3f81ca462609da85246d5aa7df2d46653734ba7c34a9c842
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/bitnami-user.sh

COPY rootfs /
RUN /opt/bitnami/scripts/laravel/postunpack.sh
RUN /opt/bitnami/scripts/php/postunpack.sh
ENV APP_VERSION="9.1.8" \
    BITNAMI_APP_NAME="laravel" \
    NODE_PATH="/opt/bitnami/node/lib/node_modules" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/node/bin:/opt/bitnami/common/bin:$PATH" \
    PHP_ENABLE_OPCACHE="0"

EXPOSE 3000 8000

WORKDIR /app
ENTRYPOINT [ "/opt/bitnami/scripts/laravel/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/laravel/run.sh" ]
