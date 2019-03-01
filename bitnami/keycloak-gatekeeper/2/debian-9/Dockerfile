FROM bitnami/minideb-extras-base:stretch-r176
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq wget
RUN mkdir -p /opt/bitnami/keycloak-gatekeeper/bin && wget https://github.com/keycloak/keycloak-gatekeeper/releases/download/v2.3.0/keycloak-proxy-linux-amd64 && mv keycloak-proxy-linux-amd64 /opt/bitnami/keycloak-gatekeeper/bin/keycloak-proxy

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="keycloak-gatekeeper" \
    BITNAMI_IMAGE_VERSION="-debian-9-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/keycloak-gatekeeper/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/keycloak-gatekeeper
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
