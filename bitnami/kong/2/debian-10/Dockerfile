FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip libc6 libgcc1 libpcre3 libssl1.1 libyaml-0-2 perl procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kong" "2.0.4-9" --checksum 8bf6d46db253fcb4c9de2452e4817f29ede3c428e49f741fd3322f6e90cf9ab8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/kong/postunpack.sh
ENV BITNAMI_APP_NAME="kong" \
    BITNAMI_IMAGE_VERSION="2.0.4-debian-10-r33" \
    PATH="/opt/bitnami/kong/bin:/opt/bitnami/kong/openresty/bin:/opt/bitnami/kong/openresty/luajit/bin:/opt/bitnami/kong/openresty/nginx/sbin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8000 8001 8443 8444

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kong/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kong/run.sh" ]
