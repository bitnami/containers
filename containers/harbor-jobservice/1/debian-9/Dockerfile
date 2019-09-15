FROM bitnami/minideb-extras-base:stretch-r362
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6
RUN . ./libcomponent.sh && component_unpack "harbor-jobservice" "1.8.2-0" --checksum e9f8a5dc6b64893eb5c88b4f730ec0458f5de04f380c9bf12491559bf75c6f34

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-jobservice" \
    BITNAMI_IMAGE_VERSION="1.8.2-debian-9-r33" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/harbor-jobservice/bin:$PATH"

VOLUME [ "/etc/jobservice", "/var/log/jobs/" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
