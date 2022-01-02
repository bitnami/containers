FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 libicu63 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-4" --checksum 53c0f1a5361a68c298f31f6701c8e8a026e77f09805d54ecfeb52cf5998d7d06
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.1-0" --checksum 3d189e4b1fcdc330fb84c14a7c6fb296deff37d3142d9a17fe0c9a5dba51ef6d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "couchdb" "3.2.1-2" --checksum f504ae80ea2e9a1aad582a8e321ad0aa446dc094a2f117c90d5390dd76fcf001
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/couchdb/postunpack.sh
ENV BITNAMI_APP_NAME="couchdb" \
    BITNAMI_IMAGE_VERSION="3.2.1-debian-10-r57" \
    LD_LIBRARY_PATH="/opt/bitnami/common/lib:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/couchdb/bin:$PATH"

VOLUME [ "/bitnami/couchdb" ]

EXPOSE 4369 5984 9100

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/couchdb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/couchdb/run.sh" ]
