FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.282-0" --checksum 473d0ab64adfe82d84dd810c28e0f22242eeffbaf74a85febf7586ce013aa7ba
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-dataflow-composed-task-runner" "2.7.1-0" --checksum f75eca5e6c8baa921542bfc0b2d1e826bdebb2667d24e794bd18039f6d7e762e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.m2 && chmod -R g+rwX /.m2

COPY rootfs /
ENV BITNAMI_APP_NAME="spring-cloud-dataflow-composed-task-runner" \
    BITNAMI_IMAGE_VERSION="2.7.1-debian-10-r61" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/scdf-composed-task-runner/entrypoint.sh" ]
CMD [ "--help" ]
