FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libcrypt1 libgeoip1 libpcre3 libssl1.1 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nginx" "1.22.0-155" --checksum f3cd00066d78eb19cab93b50ec0a73fa31b864a50ba98674a2fc0fcea2cdee43
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-151" --checksum 9690a34674f152e55c71a55275265314ed1bb29e0be8a75d7880488509f70deb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor" "2.5.3-1" --checksum e1a5d890c301ccd3571897b28bdc3447e9c387d2cd31777024e0f29187482e76
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
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
