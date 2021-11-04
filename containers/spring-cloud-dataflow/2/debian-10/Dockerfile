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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.312-0" --checksum a7e034898281dff05591e74de285ecd69899ddaaff4ce1ea9c09556ac89c9c72
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.14.1-0" --checksum 4883f9bf7d3454c72f11a6fd3218f001f049e28344045d7ab0df3bcb104deca7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-dataflow" "2.9.1-0" --checksum 0df032d2e0630ec26db240498830ab79d88cbb53cc801d883644939cceeb2a28
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-dataflow/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="spring-cloud-dataflow" \
    BITNAMI_IMAGE_VERSION="2.9.1-debian-10-r6" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-dataflow/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-dataflow/run.sh" ]
