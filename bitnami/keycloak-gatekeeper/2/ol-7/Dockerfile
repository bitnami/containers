FROM bitnami/oraclelinux-extras-base:7-r226
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc jq wget
RUN . ./libcomponent.sh && component_unpack "keycloak-gatekeeper" "2.3.0-0" --checksum 5b89d5931c0fd98f245eef0d772a55fab8d0f9c77593d33ac0110bfe053ce754

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="keycloak-gatekeeper" \
    BITNAMI_IMAGE_VERSION="2.3.0-ol-7-r1" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/keycloak-gatekeeper/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/keycloak-gatekeeper
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
