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
RUN . ./libcomponent.sh && component_unpack "nginx" "1.16.1-0" --checksum 546f22afa27cf4caf9eadb7a29bd052d90584f885225eb4d173762a70ac56b04
RUN . ./libcomponent.sh && component_unpack "kubeapps" "1.8.2-0" --checksum dff65b3c6f7fc46b32fabf82af8c692f6fa7952ef8e2828e778c0934d50e9aeb
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /postunpack.sh
RUN rm -rf /app && \
    ln -sf /opt/bitnami/kubeapps /opt/bitnami/kubeapps-dashboard && \
    mv /opt/bitnami/kubeapps/build /app
ENV BITNAMI_APP_NAME="kubeapps-dashboard" \
    BITNAMI_IMAGE_VERSION="1.8.2-debian-10-r6" \
    NAMI_PREFIX="/.nami" \
    NGINX_ENABLE_CUSTOM_PORTS="no" \
    NGINX_HTTPS_PORT_NUMBER="" \
    NGINX_HTTP_PORT_NUMBER="" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/kubeapps/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
