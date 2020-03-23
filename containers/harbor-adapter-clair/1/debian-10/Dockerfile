FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-adapter-clair" "1.0.1-0" --checksum 4928b3f0f3e24aa7d37b38b19ebebf95ea769045ff83ffff3524565365d8b15d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root harbor-adapter-clair

COPY rootfs /
ENV BITNAMI_APP_NAME="harbor-adapter-clair" \
    BITNAMI_IMAGE_VERSION="1.0.1-debian-10-r55" \
    PATH="/opt/bitnami/harbor-adapter-clair/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-adapter-clair
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-adapter-clair/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-adapter-clair/run.sh" ]
