FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.15.2-debian-11-r2" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/fluentd" \
      org.opencontainers.image.title="fluentd" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.15.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcrypt1 libgcc-s1 libjemalloc-dev libreadline-dev libreadline8 libssl-dev libssl1.1 libstdc++6 libtinfo6 procps sqlite3 tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "3.1.2-152" --checksum 46ef72d87905781f1d7ccd6f91b5f05719ba0caa043255b34f13e14a2e762a21
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "fluentd" "1.15.2-1" --checksum 4f3673cd3d9cea37252fc4cdbbd798b01cb211a869d678d149902581c4a8e4e4
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/fluentd/postunpack.sh
ENV APP_VERSION="1.15.2" \
    BITNAMI_APP_NAME="fluentd" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/common/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 5140 24224

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/fluentd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/fluentd/run.sh" ]
