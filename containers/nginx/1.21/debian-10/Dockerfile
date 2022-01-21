FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgeoip1 libpcre3 libssl1.1 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-5" --checksum 9e312b4a7e16a55d08e67c4fd69c91000e4dcc4af149d59915c49375b83852af
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx" "1.21.5-2" --checksum 947761e123cc60d01e9de9a5067f41d5f265f502814a62919e2bde61004c5b27
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log

COPY rootfs /
RUN /opt/bitnami/scripts/nginx/postunpack.sh
ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.21.5-debian-10-r23" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx/run.sh" ]
