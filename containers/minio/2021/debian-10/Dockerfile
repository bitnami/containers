FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio-client" "2020.12.18-0" --checksum 1fcab30e9493cb66ec0a75c6f4c290e6be6663dbe3cab6c41bfcb6c013069a6f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio" "2021.1.8-0" --checksum f35ab98e95450931287d6f845fdab367ed700e09341743891c0e56e2a42e13b1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/minio/postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2021.1.8-debian-10-r0" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:/opt/bitnami/common/bin:$PATH"

VOLUME [ "/certs", "/data" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/minio/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/minio/run.sh" ]
