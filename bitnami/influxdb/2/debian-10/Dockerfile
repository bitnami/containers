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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "influxdb" "2.0.6-0" --checksum 74cfe992f2042c755e3167fb108a5507e473998343195713218dc3c5a2f3abb2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/influxdb/postunpack.sh
ENV BITNAMI_APP_NAME="influxdb" \
    BITNAMI_IMAGE_VERSION="2.0.6-debian-10-r16" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/influxdb/bin:$PATH"

VOLUME [ "/bitnami/influxdb" ]

EXPOSE 8086 8088

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/influxdb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/influxdb/run.sh" ]
