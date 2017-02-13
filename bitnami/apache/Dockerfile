FROM gcr.io/stacksmith-images/minideb:jessie-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=2.4.25-r1 \
    BITNAMI_APP_NAME=apache \
    PATH=/opt/bitnami/apache/bin:$PATH

# System packages required
RUN install_packages libssl1.0.0 libaprutil1 libapr1 libc6 libuuid1 libexpat1 libpcre3 libldap-2.4-2 libsasl2-2 libgnutls-deb0-28 zlib1g libp11-kit0 libtasn1-6 libnettle4 libhogweed2 libgmp10 libffi6

# Install apache
RUN bitnami-pkg unpack apache-2.4.25-0 --checksum 8b46af7d737772d7d301da8b30a2770b7e549674e33b8a5b07480f53c39f5c3f
RUN ln -sf /opt/bitnami/apache/htdocs /app

COPY rootfs/ /

ENV APACHE_HTTP_PORT=80 \
    APACHE_HTTPS_PORT=443

WORKDIR /app

VOLUME ["/bitnami/apache"]

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "apache"]
