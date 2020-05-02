FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 07c4678654b01811f22b5bb65a8d6f8e253abd4524ebb3b78c7d3df042cf23bd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "influxdb" "1.8.0-0" --checksum 58455fdb337f33e16b6279196a6846d055a3b8f921c7b6d6d5d78d9f3e66562a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/influxdb/postunpack.sh
ENV BITNAMI_APP_NAME="influxdb" \
    BITNAMI_IMAGE_VERSION="1.8.0-debian-10-r22" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/influxdb/bin:$PATH"

VOLUME [ "/bitnami/influxdb" ]

EXPOSE 8088 8086

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/influxdb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/influxdb/run.sh" ]
