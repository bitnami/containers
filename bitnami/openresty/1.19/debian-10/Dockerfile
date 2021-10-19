FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbsd0 libc6 libexpat1 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libgd3 libgeoip1 libgpg-error0 libicu63 libjbig0 libjpeg62-turbo liblzma5 libpcre3 libpng16-16 libssl1.1 libstdc++6 libtiff5 libuuid1 libwebp6 libx11-6 libxau6 libxcb1 libxdmcp6 libxml2 libxpm4 libxslt1.1 libzstd1 perl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "openresty" "1.19.9-1-0" --checksum e0dc8afb76243430844dcd8f8c3f675cfbdfd7ad7ca58f8c0c1283db2343593b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/openresty/postunpack.sh
ENV BITNAMI_APP_NAME="openresty" \
    BITNAMI_IMAGE_VERSION="1.19.9-1-debian-10-r72" \
    PATH="/opt/bitnami/openresty/bin:/opt/bitnami/openresty/luajit/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/openresty/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/openresty/run.sh" ]
