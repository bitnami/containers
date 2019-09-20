FROM bitnami/minideb-extras-base:stretch-r366
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libgmp10 libgnutls30 libhogweed4 libidn11 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libsasl2-2 libssl1.1 libtasn1-6 zlib1g
RUN . ./libcomponent.sh && component_unpack "apache" "2.4.41-1" --checksum 4a3bb4e02de7df61c742b4fa57a044487e8d168da630cf84b29129f45e6e9225

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="apache" \
    BITNAMI_IMAGE_VERSION="2.4.41-debian-9-r41" \
    PATH="/opt/bitnami/apache/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
