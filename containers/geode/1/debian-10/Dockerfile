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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-2" --checksum b4d038090cda6aa243de5dc579a06d642918fbfc2473f114bdb443880e8a0d70
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "geode" "1.14.2-3" --checksum 770786685d32c14d1881312a0c3def6eaf30ba0382694dcfa67d71360611f19b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/geode/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="geode" \
    BITNAMI_IMAGE_VERSION="1.14.2-debian-10-r32" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/geode/bin:$PATH"

EXPOSE 1099 7070 10334 40404

WORKDIR /opt/bitnami/geode
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/geode/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/geode/run.sh" ]
