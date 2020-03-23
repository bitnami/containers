FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgeoip1 libpcre3 libssl1.1 procps sudo unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx" "1.16.1-2" --checksum 42084146b6cc40c79c8e92a305f28a899f1479ac633d5e7938b270d700a323dc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root nginx
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /opt/bitnami/scripts/nginx/postunpack.sh
ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.16.1-debian-10-r60" \
    NAMI_PREFIX="/.nami" \
    NGINX_ENABLE_CUSTOM_PORTS="no" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nginx/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nginx/run.sh" ]
