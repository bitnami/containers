FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.302-0" --checksum 59c0b7440797c7110c76959dbbce5235359b52adf62f99218b2718c04f2d67b6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.13.2-0" --checksum 92356ab39f3233604478ffaf639429461d00a66d63ad42ec0a8d29f2bea43193
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-dataflow" "2.8.2-0" --checksum ea9e15f98d8d4a43513addd01bc505c15254ba73de8fde0be00cec12101eb3d1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-dataflow/postunpack.sh
ENV BITNAMI_APP_NAME="spring-cloud-dataflow" \
    BITNAMI_IMAGE_VERSION="2.8.2-debian-10-r26" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-dataflow/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-dataflow/run.sh" ]
