FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 libpcre3 libssl1.1 libyaml-0-2 perl procps tar zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kong" "2.7.1-2" --checksum 75c06b867e8e015ccbc766e469a4c4156bb10bde6d2426c50c5c73a5d4699db1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/kong/postunpack.sh
ENV BITNAMI_APP_NAME="kong" \
    BITNAMI_IMAGE_VERSION="2.7.1-debian-10-r17" \
    PATH="/opt/bitnami/kong/bin:/opt/bitnami/kong/openresty/bin:/opt/bitnami/kong/openresty/luajit/bin:/opt/bitnami/kong/openresty/nginx/sbin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8000 8001 8443 8444

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kong/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kong/run.sh" ]
