FROM bitnami/minideb-extras-base:stretch-r368
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libicu57 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN . ./libcomponent.sh && component_unpack "couchdb" "2.3.1-0" --checksum c9065a5c3c36a21ccd96962f672c83f2bc54871efa677ce4eea01c956952a6ce

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="couchdb" \
    BITNAMI_IMAGE_VERSION="2.3.1-debian-9-r5" \
    LD_LIBRARY_PATH="/opt/bitnami/common/lib:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/couchdb/bin:$PATH"

VOLUME [ "/bitnami/couchdb" ]

EXPOSE 5984 4369 9100

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
