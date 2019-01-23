FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc
RUN bitnami-pkg install java-1.8.191-0 --checksum 8593f8fb14f68c8b801b2f791bb977c8d60004938f791ce43a37978227f37920

COPY rootfs /
ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="1.8.191-rhel-7-r1" \
    JAVA_HOME="/opt/bitnami/java" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:$PATH"

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bash" ]
