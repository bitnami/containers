FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc-s1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.3-150" --checksum 1013e2ebbe58e5dc8f3c79fc952f020fc5306ba48463803cacfbed7779173924
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "influxdb" "2.3.0-1" --checksum 9ec31bfd768b6c73ecc78c91e185f15e80b2e1c9ee06d536a3a557c9b4622a99
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/influxdb/postunpack.sh
ENV APP_VERSION="2.3.0" \
    BITNAMI_APP_NAME="influxdb" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/influxdb/bin:$PATH"

VOLUME [ "/bitnami/influxdb" ]

EXPOSE 8086 8088

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/influxdb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/influxdb/run.sh" ]
