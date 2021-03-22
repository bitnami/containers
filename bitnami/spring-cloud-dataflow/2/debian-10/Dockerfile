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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "3.4.1-0" --checksum c88c76a7b5214407821771e5fc340f0320d5ded19eada938629603a982b8b640
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "spring-cloud-dataflow" "2.7.1-0" --checksum 3f437b9721233824bb5581b6e0ed37e6ff253f16aa8d3251a3446b1d828a8c30
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/spring-cloud-dataflow/postunpack.sh
ENV BITNAMI_APP_NAME="spring-cloud-dataflow" \
    BITNAMI_IMAGE_VERSION="2.7.1-debian-10-r54" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/common/bin:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spring-cloud-dataflow/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spring-cloud-dataflow/run.sh" ]
