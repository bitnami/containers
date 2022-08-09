FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-2" --checksum 1a5468c7b552dfc8a33c5c9b214dbf7dd143a5f008cc3aa2e0418fab5eb16c5c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wildfly" "26.1.1-154" --checksum cb5e0d377d4fd64faa2d5321fa786ec61fde994a176048dc957cca7caee1c7ad
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/wildfly/postunpack.sh
ENV APP_VERSION="26.1.1" \
    BITNAMI_APP_NAME="wildfly" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:/opt/bitnami/common/bin:$PATH" \
    WILDFLY_HOME="/home/wildfly"

EXPOSE 8080 9990

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wildfly/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/wildfly/run.sh" ]
