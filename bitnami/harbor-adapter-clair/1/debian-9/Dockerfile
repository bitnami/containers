FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip
RUN . ./libcomponent.sh && component_unpack "harbor-adapter-clair" "1.0.1-0" --checksum aaf05be03d39438b7b887af1f423c07a045df4dd51116532ed4dba61e62099b3
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="harbor-adapter-clair" \
    BITNAMI_IMAGE_VERSION="1.0.1-debian-9-r4" \
    PATH="/opt/bitnami/harbor-adapter-clair/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-adapter-clair
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
