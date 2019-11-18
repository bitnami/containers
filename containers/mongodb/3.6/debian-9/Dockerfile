FROM bitnami/minideb-extras-base:stretch-r379
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libpcap0.8 libssl1.1
RUN . ./libcomponent.sh && component_unpack "mongodb" "3.6.15-0" --checksum 00d81f028748078e517256258b9b22063992fe419e62895c9fbdfbd04e84bf05

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="mongodb" \
    BITNAMI_IMAGE_VERSION="3.6.15-debian-9-r13" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mongodb/bin:$PATH"

EXPOSE 27017

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
