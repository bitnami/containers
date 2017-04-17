FROM bitnami/minideb-extras:jessie-r13
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=1.12.0-r0 \
    BITNAMI_APP_NAME=nginx \
    PATH=/opt/bitnami/nginx/sbin:$PATH

# System packages required
RUN install_packages libc6 libpcre3 libssl1.0.0 zlib1g

# Install nginx
RUN bitnami-pkg unpack nginx-1.12.0-0 --checksum ff53d1268b5856952a896974b64f22db83e05a3d20e3fb7451253c29f91e6297
RUN ln -sf /opt/bitnami/nginx/html /app

COPY rootfs/ /

ENV NGINX_HTTP_PORT=80 \
    NGINX_HTTPS_PORT=443

VOLUME ["/bitnami/nginx"]

WORKDIR /app

EXPOSE 80 443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["/run.sh"]
