FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcrypt1 libgeoip1 libpcre3 libssl1.1 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx" "1.22.0-153" --checksum b3b69cb01d9289df0b365ce675ae4297a93022696db94f8cd31a1f443244963d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-150" --checksum 8b992a5ee513c5eaca52b19232b21a93588ddf4c4850be4d47c6f19b11d1d90a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor" "2.5.3-0" --checksum b843e6f543d8a8495f0d5263c7675aa9ce7eebf02026487a81d9a1a7e9c27a95
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log

COPY rootfs /
RUN /opt/bitnami/scripts/nginx/postunpack.sh
RUN /opt/bitnami/scripts/harbor-portal/postunpack.sh
ENV APP_VERSION="2.5.3" \
    BITNAMI_APP_NAME="harbor-portal" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /opt/bitnami/harbor
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-portal/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx/run.sh" ]
