FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-adapter-clair" "2.4.1-13" --checksum fe1243bbe86bc4311fbf3a8cfd9f294986dcc00b1cc558a4394b6d94a69712b4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-adapter-clair/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-adapter-clair" \
    BITNAMI_IMAGE_VERSION="2.4.1-debian-10-r76" \
    PATH="/opt/bitnami/harbor-adapter-clair/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-adapter-clair
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-adapter-clair/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-adapter-clair/run.sh" ]
