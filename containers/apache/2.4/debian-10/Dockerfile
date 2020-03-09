FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libexpat1 libffi6 libgmp10 libgnutls30 libhogweed4 libidn2-0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libsasl2-2 libssl1.1 libtasn1-6 libunistring2 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "render-template" "1.0.0-0" --checksum 63449e5ed4ece61d7bbeda0d173b68768d9fb444922b8ffa2e1042be20687142
RUN . ./libcomponent.sh && component_unpack "apache" "2.4.41-1" --checksum 2139963ce8e8fa949271b4ac7967b783b76a4aab87dfccb8a6f6715fc96a15d1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root apache
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV APACHE_ENABLE_CUSTOM_PORTS="no" \
    APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.41-debian-10-r41" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/apache/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
