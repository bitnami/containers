FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.11-0" --checksum 8cf28afc1090b0fec1ad841012ead25b59d2d5f4212742c3d62e6007ef57850b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wildfly" "23.0.2-1" --checksum 498089eebdf347f58f63cfcdc253a220f9570e4f789b5a6b507e09afe4e4e23e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/wildfly/postunpack.sh
ENV BITNAMI_APP_NAME="wildfly" \
    BITNAMI_IMAGE_VERSION="23.0.2-debian-10-r46" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:/opt/bitnami/common/bin:$PATH" \
    WILDFLY_HOME="/home/wildfly"

EXPOSE 8080 9990

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/wildfly/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/wildfly/run.sh" ]
