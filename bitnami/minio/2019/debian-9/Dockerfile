FROM bitnami/minideb-extras-base:stretch-r298
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.7.11-0" --checksum 8d48eaf87773d02ada802a52f6bbf757c58082016eee053026538d4acc0fd6d3
RUN . ./libcomponent.sh && component_unpack "minio" "2019.7.10-0" --checksum d41ca0314ddfdbf9f66c4bba8cc35947a6ab7e37ee1cf12b316bf1260d3736b2

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.7.10-debian-9-r3" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
