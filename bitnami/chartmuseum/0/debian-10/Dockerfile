FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "chartmuseum" "0.11.0-0" --checksum ccb9cd2b2b6f2c4465845df78cacced691e35e846a9b98671003ebc04b32990e
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root chartmuseum

COPY rootfs /
ENV BITNAMI_APP_NAME="chartmuseum" \
    BITNAMI_IMAGE_VERSION="0.11.0-debian-10-r52" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/chartmuseum/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/chartmuseum/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/chartmuseum/run.sh" ]
