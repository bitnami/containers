FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio-client" "2020.10.3-0" --checksum 71d762522434a93941857bf113e5386e6795c566bf4b7d111e723e23040b0c95
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "minio" "2020.10.3-0" --checksum 8f46b136b159263b7f1e219183ccaa14100708f324decd144fabbde80b0582d2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/minio/postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2020.10.3-debian-10-r3" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:/opt/bitnami/common/bin:$PATH"

VOLUME [ "/certs", "/data" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/minio/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/minio/run.sh" ]
