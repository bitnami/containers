FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.24.2-0" --checksum 6671445790516400883182abf5e957645260585b8a9f9432a8a6b63b045b6559
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "etcd" "3.3.27-0" --checksum cff1e9c0c0a906be4aa4be22625b15cf3a928d3e6bcae2dde5cb808f6ea9935b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/etcd/postunpack.sh
ENV APP_VERSION="3.3.27" \
    BITNAMI_APP_NAME="etcd" \
    BITNAMI_IMAGE_VERSION="3.3.27-debian-10-r2" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/etcd/bin:$PATH"

EXPOSE 2379 2380

WORKDIR /opt/bitnami/etcd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/etcd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/etcd/run.sh" ]
