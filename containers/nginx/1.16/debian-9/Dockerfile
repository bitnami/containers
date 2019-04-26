FROM bitnami/minideb-extras-base:stretch-r231
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libpcre3 libssl1.1 zlib1g
RUN . ./libcomponent.sh && component_unpack "nginx" "1.16.0-0" --checksum b08c5b2a428e2e54726d47e290102496780db1ddd4a0a67bed82da6c34e56784

COPY rootfs /
RUN /prepare.sh

ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.16.0-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 8080 8443
VOLUME [ "/app" "/certs" ]
WORKDIR /app
USER 1001

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
