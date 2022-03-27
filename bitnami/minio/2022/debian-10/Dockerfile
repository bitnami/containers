FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-10" --checksum 35c818ba3f4b5aae905959bc7d3a5e81fc63786e3c662b604612c0aa7fcda8fd
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio-client" "2022.3.17-0" --checksum 6674036b572d909c4f8957984ab29238db49e25e8f248cb83a4c7a1d12e864cf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio" "2022.3.26-0" --checksum 5401648b30d411a250d95103039242e81e105280960bb221127efd6a02fadf16
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/minio-client/postunpack.sh
RUN /opt/bitnami/scripts/minio/postunpack.sh
ENV APP_VERSION="2022.3.26" \
    BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2022.3.26-debian-10-r1" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/certs", "/data" ]

EXPOSE 9000 9001

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/minio/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/minio/run.sh" ]
