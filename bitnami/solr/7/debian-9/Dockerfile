FROM bitnami/minideb-extras:stretch-r226
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libblkid1 libc6 libffi6 libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libuuid1 lsof zlib1g
RUN bitnami-pkg install java-1.8.191-20 --checksum e193fab6c3c4de4d30f81a09d3b33978baa31761aaa330e39ce5ae8753db4133
RUN bitnami-pkg unpack solr-7.6.0-0 --checksum afe7b9973e8f6dc54178a045fc5960f8815fb8aaea8c7a5e87179e9b4cbcd90e

COPY rootfs /
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="7.6.0-debian-9-r8" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:$PATH" \
    SOLR_CORE="" \
    SOLR_CORE_CONF_DIR="_default" \
    SOLR_PORT_NUMBER="8983" \
    SOLR_SERVER_DIRECTORY="server"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
