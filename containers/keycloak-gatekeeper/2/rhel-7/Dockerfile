FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-base-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="rhel-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates glibc jq wget
RUN . ./libcomponent.sh && component_unpack "keycloak-gatekeeper" "2.3.0-0" --checksum cc3bd3d485dd2a3ec517264fd475feab5bf6f92869691e290027dfbec4db953f

COPY rootfs /
RUN /prepare.sh
ENV BITNAMI_APP_NAME="keycloak-gatekeeper" \
    BITNAMI_IMAGE_VERSION="2.3.0-rhel-7-r0" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/keycloak-gatekeeper/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/keycloak-gatekeeper
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
