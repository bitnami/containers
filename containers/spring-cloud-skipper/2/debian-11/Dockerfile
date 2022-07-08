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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.333-150" --checksum 02a91d298bbe3bb5d240f635802a50b2970b19eba960c1804b7275f88a944bb3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.25.3-1" --checksum 042fde05fc288b0b4dc0e0de0348990e95e75c2222927f5c961ea239167a0a6f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-skipper" "2.8.4-151" --checksum e817ddec7c8703cb38a4ef38e7fec9c1c5c189328e440dcbbc2b781520dfe024
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-skipper/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="2.8.4" \
    BITNAMI_APP_NAME="spring-cloud-skipper" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-skipper/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-skipper/run.sh" ]
