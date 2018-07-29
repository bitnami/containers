FROM bitnami/minideb-extras:stretch-r91
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/nginx/conf" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libpcre3 libssl1.1 zlib1g
RUN bitnami-pkg unpack nginx-1.14.0-2 --checksum 9bc17f3a88adb34deb2a10e337b8112f0ff31c633bb09c9ec9b3b53948058043
RUN ln -sf /opt/bitnami/nginx/html /app
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/error.log

COPY rootfs /
ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.14.0-debian-9-r23" \
    NGINX_DAEMON_GROUP="nginx" \
    NGINX_DAEMON_USER="nginx" \
    NGINX_HTTPS_PORT_NUMBER="8443" \
    NGINX_HTTP_PORT_NUMBER="8080" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nginx","-g","daemon off;"]
