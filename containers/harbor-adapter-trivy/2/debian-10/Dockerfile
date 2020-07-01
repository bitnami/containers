FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps rpm tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-adapter-trivy" "2.0.1-0" --checksum 0fe41204d74cf74ef4290206f7763af650bf45fff07e62ab4f70081cb9d56b38
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-1" --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-adapter-trivy/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-adapter-trivy" \
    BITNAMI_IMAGE_VERSION="2.0.1-debian-10-r1" \
    PATH="/opt/bitnami/harbor-adapter-trivy/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /opt/bitnami/harbor-adapter-trivy
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-adapter-trivy/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-adapter-trivy/run.sh" ]
