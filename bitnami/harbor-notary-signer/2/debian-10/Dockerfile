FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-notary-signer" "2.4.1-12" --checksum 24205c8b342cf0fc13d06e420dbb5e5ab69e1e625861bb274b1b1a46a21ac78e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-notary-signer/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-notary-signer" \
    BITNAMI_IMAGE_VERSION="2.4.1-debian-10-r78" \
    PATH="/opt/bitnami/harbor-notary-signer/bin:/opt/bitnami/common/bin:$PATH" \
    SERVICE_NAME="notary_signer"

VOLUME [ "/etc/notary" ]

EXPOSE 7899

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-notary-signer/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-notary-signer/run.sh" ]
