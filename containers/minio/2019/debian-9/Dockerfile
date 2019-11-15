FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates jq
RUN . ./libcomponent.sh && component_unpack "minio-client" "2019.10.9-0" --checksum a753ccb20427d6af60d2849b74dd6f8a76c46cddba33e37c136d1e67efd256bf
RUN . ./libcomponent.sh && component_unpack "minio" "2019.10.12-0" --checksum 94c5e0161e19acf06adcf205963ec2bd6f566b62113d669259629c0ff1d5c7d1

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="minio" \
    BITNAMI_IMAGE_VERSION="2019.10.12-debian-9-r13" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/minio-client/bin:/opt/bitnami/minio/bin:$PATH"

VOLUME [ "/data", "/certs" ]

EXPOSE 9000

WORKDIR /opt/bitnami/minio-client
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
