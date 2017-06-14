FROM bitnami/minideb-extras:jessie-r17
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libfontconfig1 libfreetype6 libgcc1 libglib2.0-0 liblzma5 libpcre3 libpng12-0 libselinux1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27
RUN bitnami-pkg unpack zookeeper-3.4.10

COPY rootfs /

ENV BITNAMI_APP_NAME="zookeeper" \
    BITNAMI_IMAGE_VERSION="3.4.10-r0" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:$PATH" \
    ZOO_INIT_LIMIT="10" \
    ZOO_PORT_NUMBER="2181" \
    ZOO_SERVERS="" \
    ZOO_SERVER_ID="1" \
    ZOO_SYNC_LIMIT="5" \
    ZOO_TICK_TIME="2000"



VOLUME ["/bitnami/zookeeper"]

EXPOSE 2181 2888 3888

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
