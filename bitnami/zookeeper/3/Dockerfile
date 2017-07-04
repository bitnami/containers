FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libfontconfig1 libfreetype6 libgcc1 libglib2.0-0 liblzma5 libpcre3 libpng12-0 libselinux1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.131-0 --checksum 5b122a36c8ba44e2f9eb8cbb9b62dd87963742c46f85a04019115d2d43c69e33
RUN bitnami-pkg unpack zookeeper-3.4.10-1 --checksum a77c4185e8cc742bae3ab9b89f70ae70383329c6290df1c26f7fb3b003a7f6de

COPY rootfs /

ENV BITNAMI_APP_NAME="zookeeper" \
    BITNAMI_IMAGE_VERSION="3.4.10-r2" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:$PATH" \
    ZOO_INIT_LIMIT="10" \
    ZOO_PORT_NUMBER="2181" \
    ZOO_SERVERS="" \
    ZOO_SERVER_ID="1" \
    ZOO_SYNC_LIMIT="5" \
    ZOO_TICK_TIME="2000"




EXPOSE 2181 2888 3888

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
