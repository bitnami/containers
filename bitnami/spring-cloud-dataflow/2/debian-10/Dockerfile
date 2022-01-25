FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-1" --checksum 064c0df11dedb32c3a3e13c1daac87085ed44ccd816898f11e7a2496ece5d9ee
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.17.2-1" --checksum 73d43822094e9e5881673a0d0b69ca20a39af8bff4b5a48070675d1b064c9d59
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-dataflow" "2.9.2-2" --checksum 03c876dc1880ca5101ec6c2ab39b2868165ffc1e98f9aec451ec591504812781
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-dataflow/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="spring-cloud-dataflow" \
    BITNAMI_IMAGE_VERSION="2.9.2-debian-10-r5" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-dataflow/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-dataflow/run.sh" ]
