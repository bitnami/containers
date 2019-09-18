FROM bitnami/minideb-extras-base:stretch-r363
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgeoip1 libpcre3 libssl1.1 zlib1g
RUN . ./libcomponent.sh && component_unpack "nginx" "1.16.1-0" --checksum 9beea2a7aa9a47c4b52067916bf19b0fd4695c89a2bd538d6d67a4e354f5334a
RUN . ./libcomponent.sh && component_unpack "harbor" "1.8.3-0" --checksum 0addadb96d3ee5dec0487e9977600436ea51ebe245bc1b2cf025f0d52ed2ccbf
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /postunpack.sh
RUN /postunpack-harbor-portal.sh
ENV BITNAMI_APP_NAME="harbor-portal" \
    BITNAMI_IMAGE_VERSION="1.8.3-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/harbor/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /opt/bitnami/harbor
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
