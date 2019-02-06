FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc zlib
RUN bitnami-pkg install java-11.0.2-0 --checksum fe79561c4dd339f9d68f633237b47b06c719286f99b319282a6c819835e8a110

COPY rootfs /
ENV BITNAMI_APP_NAME="java" \
    BITNAMI_IMAGE_VERSION="11.0.2-rhel-7-r0" \
    JAVA_HOME="/opt/bitnami/java" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:$PATH"

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "bash" ]
