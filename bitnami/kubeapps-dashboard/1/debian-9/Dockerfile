FROM bitnami/minideb-extras-base:stretch-r63
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/bitnami/nginx/conf" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages libc6 libpcre3 libssl1.1 zlib1g
RUN . ./libcomponent.sh && component_unpack "nginx" "1.14.0-5" --checksum 9282eb39ae72201d15a72edf64e5751da803860caafb6b17599a9b95c720b30a
RUN . ./libcomponent.sh && component_unpack "kubeapps-dashboard" "1.0.0-beta.4-0" --checksum 5a8a34840c3a0de25d3d0741130816f127f7632cfc595431952792979f288382
RUN ln -sf /opt/bitnami/nginx/html /app
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/error.log

COPY rootfs /
RUN /prepare.sh
RUN rm -rf /opt/bitnami/nginx/html && mv /opt/bitnami/kubeapps-dashboard/build /opt/bitnami/nginx/html
ENV BITNAMI_APP_NAME="kubeapps-dashboard" \
    BITNAMI_IMAGE_VERSION="1.0.0-beta.4-debian-9-r0" \
    NGINX_DAEMON_GROUP="" \
    NGINX_DAEMON_USER="" \
    NGINX_HTTP_PORT_NUMBER="8080" \
    PATH="/opt/bitnami/nginx/sbin:/opt/bitnami/kubeapps-dashboard/bin:$PATH"

EXPOSE 8080

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
