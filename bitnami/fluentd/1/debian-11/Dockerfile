FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcrypt1 libgcc-s1 libjemalloc-dev libncurses5-dev libreadline-dev libreadline8 libssl-dev libssl1.1 libstdc++6 libtinfo6 procps sqlite3 tar wget zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "3.1.2-150" --checksum 00b238602b8c973e7a85e45f2f24bbe9cf200802ea37578e7689b3cc0a3415b7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "fluentd" "1.15.0-0" --checksum 474c226f6c2dcf0f09fb239389334d267e880e2cd60c7c70f7fe701182f5dcee
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/fluentd/postunpack.sh
ENV APP_VERSION="1.15.0" \
    BITNAMI_APP_NAME="fluentd" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/common/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 5140 24224

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/fluentd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/fluentd/run.sh" ]
