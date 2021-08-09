FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libffi6 libgcc1 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.11-0" --checksum 28b91ef5db9ad93e704881400703e4085bd82f016be15e3cf8760df044da9490
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "12.22.4-0" --checksum 1dae67c7cf4c864a5c1626bc529f37f021b72814c1044c6deab7a7feb03954a2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse-dashboard" "2.1.0-3" --checksum 0f61900845142579626ae74babbe11b70449c5801eb099a7c32e6765c67d7d8f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse-dashboard/postunpack.sh
ENV BITNAMI_APP_NAME="parse-dashboard" \
    BITNAMI_IMAGE_VERSION="2.1.0-debian-10-r433" \
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
