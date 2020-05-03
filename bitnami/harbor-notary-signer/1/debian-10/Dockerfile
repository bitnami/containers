FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-notary-signer" "1.10.2-0" --checksum 727c0df2ded62dca4c65ef558f3d742f048289d77382addcb5e9ab2b98e404b2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-notary-signer/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-signer" \
    BITNAMI_IMAGE_VERSION="1.10.2-debian-10-r29" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-notary-signer/bin:/opt/bitnami/common/bin:$PATH" \
    SERVICE_NAME="notary_signer"

VOLUME [ "/etc/notary" ]

EXPOSE 7899

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-notary-signer/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-notary-signer/run.sh" ]
