FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-1" --checksum 28dc75dff64df07e67b711d20859c24ebc996db0eaac06138553341d0f769299
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio-client" "2021.11.5-0" --checksum a617717991dfbe1364a86bba6004b102d70290a41c9d2a0009d93d3a79f46ba5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio" "2021.10.27-0" --checksum dc4051c7024721166f2d89b15a3b9df43ecd36f05de34e030f581615570e5a26
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/minio-client/postunpack.sh
RUN /opt/bitnami/scripts/minio/postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2021.10.27-debian-10-r9" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:/opt/bitnami/common/bin:$PATH"

VOLUME [ "/certs", "/data" ]

EXPOSE 9000 9001

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/minio/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/minio/run.sh" ]
