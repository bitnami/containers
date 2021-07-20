FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gzip imagemagick libc6 libgcc1 libgmp-dev libjemalloc-dev libncurses5-dev libncurses6 libreadline-dev libreadline7 libssl-dev libssl1.1 libstdc++6 libtinfo6 libxml2-dev libxslt1-dev procps sqlite3 tar wget zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.8-1" --checksum aa85db57a30d79ac61743dffac4b1cbdc58b7736ffbffd873ed32248b07f9e51
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "fluentd" "1.13.2-0" --checksum 2d89c6d9b3a8dbae5d5d0ed2e16a7faca4d650ebc7400c58223e5a7f91a15ee6
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/fluentd/postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.13.2-debian-10-r7" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/common/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 5140 24224

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/fluentd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/fluentd/run.sh" ]
