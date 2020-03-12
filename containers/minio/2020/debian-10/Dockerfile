FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl jq procps sudo unzip
RUN . ./libcomponent.sh && component_unpack "minio-client" "2020.3.6-0" --checksum b369de697d2b8c014bbac2a2cc726909968ea3c7720ba44b4bfa31722bdb2f7a
RUN . ./libcomponent.sh && component_unpack "minio" "2020.3.9-0" --checksum 38d320fb73840a1943163834aafececb1a7e486386e60137913beed42ea1ed8a
RUN . ./libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root minio

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2020.3.9-debian-10-r2" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:/opt/bitnami/gosu/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
