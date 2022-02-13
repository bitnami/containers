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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-5" --checksum 5bea54f21135133d1d0df7486e419d204f846d8acac4c83e1c6359a703fc9244
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "geode" "1.14.3-1" --checksum 634379bf59dad39fa29984bf4863a19fa116ea6ea51f7cad163fb72ae7d2714e
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/geode/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="geode" \
    BITNAMI_IMAGE_VERSION="1.14.3-debian-10-r16" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/geode/bin:$PATH"

EXPOSE 1099 7070 10334 40404

WORKDIR /opt/bitnami/geode
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/geode/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/geode/run.sh" ]
