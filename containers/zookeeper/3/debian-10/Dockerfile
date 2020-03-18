FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "java" "11.0.6-0" --checksum f7446f8bec72b6b2606d37ba917accc243e6cd4e722700c39ef83832c46fb0c6
RUN . ./libcomponent.sh && component_unpack "zookeeper" "3.6.0-0" --checksum 1f7efe908883b1e3a34b54eacc8fa80d8e8c3a240bf91a403bd127490d19f9c5
RUN . ./libcomponent.sh && component_unpack "wait-for-port" "1.0.0-1" --checksum 07c4678654b01811f22b5bb65a8d6f8e253abd4524ebb3b78c7d3df042cf23bd
RUN . ./libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root zookeeper

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="zookeeper" \
    BITNAMI_IMAGE_VERSION="3.6.0-debian-10-r8" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:/opt/bitnami/common/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 2181 2888 3888 8080

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
