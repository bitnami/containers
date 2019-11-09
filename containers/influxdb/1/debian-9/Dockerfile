FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "influxdb" "1.7.9-0" --checksum 4d77d238e8688ba993689c7df9cdfbf053eccf5e0fd31dd0117a858e10d1bb13

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="influxdb" \
    BITNAMI_IMAGE_VERSION="1.7.9-debian-9-r2" \
    PATH="/opt/bitnami/influxdb/bin:$PATH"

VOLUME [ "/bitnami/influxdb" ]

EXPOSE 8088 8086

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
