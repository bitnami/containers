FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gzip imagemagick jq libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.2-0" --checksum c8db45970c71193a683d32eacfe29d7219a1ea5b1c1d743fbd3171a56fccad52
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse-dashboard" "2.1.0-3" --checksum 0f61900845142579626ae74babbe11b70449c5801eb099a7c32e6765c67d7d8f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse-dashboard/postunpack.sh
ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="2.1.0-debian-10-r401" \
    PARSE_APP_ID="myappID" \
    PARSE_DASHBOARD_APP_NAME="" \
    PARSE_DASHBOARD_PASSWORD="bitnami" \
    PARSE_DASHBOARD_USER="" \
    PARSE_HOST="parse" \
    PARSE_MASTER_KEY="mymasterKey" \
    PARSE_MOUNT_PATH="/parse" \
    PARSE_PORT_NUMBER="1337" \
    PARSE_PROTOCOL="http" \
    PARSE_USE_HOSTNAME="no" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:/opt/bitnami/parse-dashboard/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000 4040

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse-dashboard/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse-dashboard/run.sh" ]
