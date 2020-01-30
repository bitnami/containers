FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname jq libaio-devel procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "minio-client" "2020.1.25-0" --checksum 3ca8cd6df134163a5699fa9f9292feeca40b4d08357a1ab558387d55c4893d8b
RUN . ./libcomponent.sh && component_unpack "minio" "2020.1.25-0" --checksum 8aaff7aa2c0ab166a1b03621b197372688973445c553ff2e05035119b70be0e5
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2020.1.25-ol-7-r4" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
