FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libc6 libgcc1 ncurses-bin procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.312-0" --checksum a7e034898281dff05591e74de285ecd69899ddaaff4ce1ea9c09556ac89c9c72
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "geode" "1.14.2-0" --checksum a28a18ab51433ecce8c98fbadb8c039d0f0700b67cad0f0ab9385a1a49271d65
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/geode/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="geode" \
    BITNAMI_IMAGE_VERSION="1.14.2-debian-10-r14" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/geode/bin:$PATH"

EXPOSE 1099 7070 10334 40404

WORKDIR /opt/bitnami/geode
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/geode/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/geode/run.sh" ]
