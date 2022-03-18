FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libexpat1 libffi6 libgcc1 libgmp10 libgnutls30 libhogweed4 libicu63 libidn2-0 libldap-2.4-2 liblzma5 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libsasl2-2 libssl1.1 libstdc++6 libtasn1-6 libunistring2 libxml2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 97c2ae4b001c5937e888b920bee7b1a40a076680caac53ded6d10f6207d54565
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "apache" "2.4.53-0" --checksum 716e4948a2c40f0a0cc5b1656052aeef916a79152250b0b6c1392dd1187f575a
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/apache/postunpack.sh
ENV APACHE_HTTPS_PORT_NUMBER="" \
    APACHE_HTTP_PORT_NUMBER="" \
    BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.53-debian-10-r4" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/apache/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/apache/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/apache/run.sh" ]
