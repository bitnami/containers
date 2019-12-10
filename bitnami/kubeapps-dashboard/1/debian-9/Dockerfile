FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 libgeoip1 libpcre3 libssl1.1 procps unzip zlib1g
RUN . ./libcomponent.sh && component_unpack "nginx" "1.16.1-3" --checksum 1a8f6f36c91ddd0f73a1bb5fd00f1e1d099213dff38c8032abc197d887df3531
RUN . ./libcomponent.sh && component_unpack "kubeapps" "1.7.1-0" --checksum c9ad9b9e36d43eb295ec36b72a1a109b4b3e0f1c72d12a7fb71eb58bcb4d2093
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /postunpack.sh
RUN rm -rf /app && \
    ln -sf /opt/bitnami/kubeapps /opt/bitnami/kubeapps-dashboard && \
    mv /opt/bitnami/kubeapps/build /app
ENV BITNAMI_APP_NAME="kubeapps-dashboard" \
    BITNAMI_IMAGE_VERSION="1.7.1-debian-9-r15" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/kubeapps/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
