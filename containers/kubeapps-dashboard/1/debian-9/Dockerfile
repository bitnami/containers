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
RUN . ./libcomponent.sh && component_unpack "nginx" "1.16.1-5" --checksum 37288b74d5e7b3a0fdb38454c059fb0cefbaa5d28f04fe0bb5ed9d7526a6b100
RUN . ./libcomponent.sh && component_unpack "kubeapps" "1.7.2-0" --checksum f683dffff1b57e15678f00a434031595aeea271b524e6aaac4dd7396ada40c1e
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /postunpack.sh
RUN rm -rf /app && \
    ln -sf /opt/bitnami/kubeapps /opt/bitnami/kubeapps-dashboard && \
    mv /opt/bitnami/kubeapps/build /app
ENV BITNAMI_APP_NAME="kubeapps-dashboard" \
    BITNAMI_IMAGE_VERSION="1.7.2-debian-9-r20" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/kubeapps/bin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
