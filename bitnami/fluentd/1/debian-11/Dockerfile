FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcrypt1 libgcc-s1 libjemalloc-dev libncurses5-dev libreadline-dev libreadline8 libssl-dev libssl1.1 libstdc++6 libtinfo6 procps sqlite3 tar wget zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "3.1.2-151" --checksum 986d7ff50c9b7a30c67f87ac726130b794162ba3cdd3950ddff7aa0ff4ea2940
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "fluentd" "1.15.1-0" --checksum a842d29f3c1619bbce4105358a6df252999f72e1e4dc3f6e575f5b0cc4c2736f
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/fluentd/postunpack.sh
ENV APP_VERSION="1.15.1" \
    BITNAMI_APP_NAME="fluentd" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/common/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 5140 24224

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/fluentd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/fluentd/run.sh" ]
