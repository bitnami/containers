FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc-s1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.333-153" --checksum 7ce94aacf3e51f137d94316b7767e590e7f827c0268f0d5336fd65cc7192aae8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.25.3-2" --checksum 84ce4016efca8b6a6713d69e9d7c19003d4a530f8b420fb8cdcaa9cf9af47ee6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-dataflow" "2.9.4-151" --checksum 6dc939588f5a54fcab04cdc0b88e7b2fd8b61b2ac35f9dd454a25ed8ffc011ec
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-dataflow/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="2.9.4" \
    BITNAMI_APP_NAME="spring-cloud-dataflow" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-dataflow/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-dataflow/run.sh" ]
