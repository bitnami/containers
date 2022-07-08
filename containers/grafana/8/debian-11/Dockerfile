FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libfontconfig procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "grafana" "8.5.6-1" --checksum 30ba3b70575b81bddb1f98990b486065beb5f93f6ca3d6437dbb11d1ace05650
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/grafana/postunpack.sh
ENV APP_VERSION="8.5.6" \
    BITNAMI_APP_NAME="grafana" \
    PATH="/opt/bitnami/grafana/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3000

WORKDIR /opt/bitnami/grafana
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/grafana/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/grafana/run.sh" ]
