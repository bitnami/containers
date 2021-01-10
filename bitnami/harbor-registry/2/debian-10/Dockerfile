FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-registry" "2.1.2-0" --checksum 2ae29163ef0e05be8e95b1ab050797e321905d72a892f05981ac3360fa1ccce2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-2" --checksum 4d858ac600c38af8de454c27b7f65c0074ec3069880cb16d259a6e40a46bbc50
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-registry/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-registry" \
    BITNAMI_IMAGE_VERSION="2.1.2-debian-10-r31" \
    PATH="/opt/bitnami/harbor-registry/bin:/opt/bitnami/common/bin:$PATH"

VOLUME [ "/etc/registry", "/storage", "/var/lib/registry" ]

EXPOSE 5000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-registry/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-registry/run.sh" ]
