FROM bitnami/minideb-extras-base:stretch-r182
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq libc6 wget
RUN . ./libcomponent.sh && component_unpack "keycloak-gatekeeper" "2.3.0-0" --checksum e1dedb739156f14ab714bcaee13c2c929186782cf22ddf8746bbb0b17439a8c3

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="keycloak-gatekeeper" \
    BITNAMI_IMAGE_VERSION="2.3.0-debian-9-r2" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/keycloak-gatekeeper/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/keycloak-gatekeeper
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
