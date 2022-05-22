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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-0" --checksum 0603c8eaf6d24e76563431e36e512da06bfebb3a06ede31b3e84d9879213c162
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-0" --checksum 255bc547614ce8052f416a74c58cfb916f724876315f15b816e0eb98b2bded35
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "keycloak" "18.0.0-0" --checksum fc4057939efadbc5b7a281e0d33475c2b96539014f4b566d1ecbd73b63c81d24
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/keycloak/postunpack.sh
ENV APP_VERSION="18.0.0" \
    BITNAMI_APP_NAME="keycloak" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/keycloak/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/keycloak/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/keycloak/run.sh" ]
