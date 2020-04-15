FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registry" "1.10.2-0" --checksum 8a47b6a4960e76dd3d533dfaa5e52009fcb9b9d6b84c326a0d111094e9193558
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-registry/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registry" \
    BITNAMI_IMAGE_VERSION="1.10.2-debian-10-r6" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-registry/bin:/opt/bitnami/common/bin:$PATH"

VOLUME [ "/etc/registry", "/storage", "/var/lib/registry" ]

EXPOSE 5000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-registry/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-registry/run.sh" ]
