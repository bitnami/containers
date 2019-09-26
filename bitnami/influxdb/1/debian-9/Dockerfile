FROM bitnami/minideb-extras-base:stretch-r369
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "influxdb" "1.7.8-0" --checksum df7df066c5644eda0adb6801f9edd85b85f9aa5c761adf335c380c4fff2f351b

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="influxdb" \
    BITNAMI_IMAGE_VERSION="1.7.8-debian-9-r0" \
    PATH="/opt/bitnami/influxdb/bin:$PATH"

VOLUME [ "/bitnami/influxdb" ]

EXPOSE 8088 8086

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
