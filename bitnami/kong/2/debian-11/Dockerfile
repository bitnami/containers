FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.8.1-debian-11-r40" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/kong" \
      org.opencontainers.image.title="kong" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.8.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcrypt1 libgcc-s1 libpcre3 libprotobuf-dev libssl1.1 libyaml-0-2 perl procps tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kong" "2.8.1-16" --checksum 3b14f93905bd5026dda7acb6e2085cedf73238d80860520a796ab9bd48a8edaf
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/kong/postunpack.sh
ENV APP_VERSION="2.8.1" \
    BITNAMI_APP_NAME="kong" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kong/bin:/opt/bitnami/kong/openresty/bin:/opt/bitnami/kong/openresty/luajit/bin:/opt/bitnami/kong/openresty/nginx/sbin:$PATH"

EXPOSE 8000 8001 8443 8444

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kong/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kong/run.sh" ]
