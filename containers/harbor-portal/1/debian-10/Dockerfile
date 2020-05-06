FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgeoip1 libpcre3 libssl1.1 procps sudo unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx" "1.17.10-0" --checksum a40de912e99beeaf5a2b9c1c33c064fec4483cf6b0a5e67867c8be33acaeb670
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor" "1.10.2-0" --checksum c1b609652a183ccfb9a901a292448445b5170ddfd0db1909fd013212c938703c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-0" --checksum 582d501eeb6b338a24f417fededbf14295903d6be55c52d66c52e616c81bcd8c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /opt/bitnami/scripts/nginx/postunpack.sh
RUN /opt/bitnami/scripts/harbor-portal/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-portal" \
    BITNAMI_IMAGE_VERSION="1.10.2-debian-10-r29" \
    NAMI_PREFIX="/.nami" \
    NGINX_ENABLE_CUSTOM_PORTS="no" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/harbor/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /opt/bitnami/harbor
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx/run.sh" ]
