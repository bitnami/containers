FROM bitnami/minideb-extras-base:stretch-r229
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libpcre3 libssl1.1 zlib1g
RUN . ./libcomponent.sh && component_unpack "nginx" "1.14.2-21" --checksum 73c924db078bebc7173aa5a596036285d1da41cbe985d1e4cc024f681e6dca52

COPY rootfs /
RUN /prepare.sh

ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.14.2-debian-9-r125" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 8080 8443
VOLUME [ "/app" "/certs" ]
WORKDIR /app
USER 1001

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
