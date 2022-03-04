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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-8" --checksum d5670d09ac0e679ae28306e417e77e91b44051908ca3a82259efcd70764b996f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.21.1-1" --checksum d0927015892d9e13182fbf5242b41d75de0bf5eca43106bb1c0f0f936b05144a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-dataflow" "2.9.2-7" --checksum 32f7fbc01a2c1603734de1bec1e722932cfd351fa2e83334ef378cdc93064cad
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-dataflow/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="spring-cloud-dataflow" \
    BITNAMI_IMAGE_VERSION="2.9.2-debian-10-r40" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-dataflow/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-dataflow/run.sh" ]
