FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.0-3" --checksum 7521d9a4f9e4e182bf32977e234026caa7b03759799868335bccb1edd8f8fd12
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "influxdb" "2.0.4-0" --checksum 2b292db366d602f8fcaed20e1df647ef4ba2450592606d078f6fef54e7cd44a8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/influxdb/postunpack.sh
ENV BITNAMI_APP_NAME="influxdb" \
    BITNAMI_IMAGE_VERSION="2.0.4-debian-10-r40" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/influxdb/bin:$PATH"

VOLUME [ "/bitnami/influxdb" ]

EXPOSE 8086 8088

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/influxdb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/influxdb/run.sh" ]
