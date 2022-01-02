FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libc6 procps rsync tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-4" --checksum 53c0f1a5361a68c298f31f6701c8e8a026e77f09805d54ecfeb52cf5998d7d06
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.13-0" --checksum 9552e53ccd3b0ec85a82c31c26a1462260e28b7c58770a5c53560afb02ec66d9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "keycloak" "16.1.0-0" --checksum a6aaa2d99896c8f9bc13b2053ddbb4ad4d0336ab0c26e80e3be5090b86488c2e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/keycloak/postunpack.sh
ENV BITNAMI_APP_NAME="keycloak" \
    BITNAMI_IMAGE_VERSION="16.1.0-debian-10-r2" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/keycloak/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/keycloak/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/keycloak/run.sh" ]
