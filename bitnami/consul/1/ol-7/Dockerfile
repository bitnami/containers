FROM bitnami/oraclelinux-extras-base:7-r422
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN . ./libcomponent.sh && component_unpack "consul" "1.6.1-1" --checksum 1663aa8683f394a56a4c54ff20e164c12914756f55509b234e99e33f07d185df

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="consul" \
    BITNAMI_IMAGE_VERSION="1.6.1-ol-7-r9" \
    PATH="/opt/bitnami/consul/bin:$PATH"

EXPOSE 8300 8301 8500 8600

EXPOSE 8301/udp 8600/udp

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
