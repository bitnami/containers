FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbsd0 libc6 libexpat1 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libgd3 libgeoip1 libgpg-error0 libicu63 libjbig0 libjpeg62-turbo liblzma5 libpcre3 libpng16-16 libssl1.1 libstdc++6 libtiff5 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxml2 libxpm4 libxslt1.1 libzstd1 perl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "openresty" "1.19.9-1-2" --checksum 6fb68eebbb3fea3e9c25b44b887cdbf35b55d784436f8c583b4f2ca2ffbfc333
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/openresty/postunpack.sh
ENV BITNAMI_APP_NAME="openresty" \
    BITNAMI_IMAGE_VERSION="1.19.9-1-debian-10-r165" \
    PATH="/opt/bitnami/openresty/bin:/opt/bitnami/openresty/luajit/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/openresty/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openresty/run.sh" ]
