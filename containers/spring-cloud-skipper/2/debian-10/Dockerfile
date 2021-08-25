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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.12.0-0" --checksum 431d61b51a6451b6896af533581d40e0f4d28732d9eca6145ec109b178c7049c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-skipper" "2.7.1-0" --checksum a304916fc6e7547de71bf8a87c685108a5b1ec26958ca622de1574c2d132bfd7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-skipper/postunpack.sh
ENV BITNAMI_APP_NAME="spring-cloud-skipper" \
    BITNAMI_IMAGE_VERSION="2.7.1-debian-10-r57" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-skipper/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-skipper/run.sh" ]
