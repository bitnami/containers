FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.12-11" --checksum 18529e5433b2ff7007527ec2fa5b608cb6432e27ec3e6a9f3ab94fcdb7586475
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.8-0" --checksum dc657282c02ae39ebbb8c870cda6cd5b8a3ec8c45725643019e8304d97fcc2a2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse-dashboard" "3.3.0-0" --checksum 294358f186fef8d59fee8313ff4977f12591c8f3bab00ec343ae995c5db4d638
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse-dashboard/postunpack.sh
ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="3.3.0-debian-10-r2" \
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
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/parse-dashboard/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000 4040

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse-dashboard/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse-dashboard/run.sh" ]
