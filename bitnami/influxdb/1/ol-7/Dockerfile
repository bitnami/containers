FROM bitnami/oraclelinux-extras-base:7-r463
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages glibc
RUN . ./libcomponent.sh && component_unpack "influxdb" "1.7.9-0" --checksum 7fe4650e66b71e205a4aa4c9028463d0f0399538f685352792decf2b6f93a65f

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="influxdb" \
    BITNAMI_IMAGE_VERSION="1.7.9-ol-7-r2" \
    PATH="/opt/bitnami/influxdb/bin:$PATH"

VOLUME [ "/bitnami/influxdb" ]

EXPOSE 8088 8086

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
