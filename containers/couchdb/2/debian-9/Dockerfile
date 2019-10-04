FROM bitnami/minideb-extras-base:stretch-r375
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libicu57 libssl1.1 libstdc++6 libtinfo5 zlib1g
RUN . ./libcomponent.sh && component_unpack "couchdb" "2.3.1-1" --checksum e488860a02c421922570879a234d5eab6f374f782cab57652cb960ee3ed189d4

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="couchdb" \
    BITNAMI_IMAGE_VERSION="2.3.1-debian-9-r14" \
    LD_LIBRARY_PATH="/opt/bitnami/common/lib:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/couchdb/bin:$PATH"

VOLUME [ "/bitnami/couchdb" ]

EXPOSE 5984 4369 9100

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
