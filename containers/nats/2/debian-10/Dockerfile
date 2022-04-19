FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-10" --checksum 97c2ae4b001c5937e888b920bee7b1a40a076680caac53ded6d10f6207d54565
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "nats" "2.8.0-0" --checksum 17ed327e7f4663e9d2293f60a22363c07a83dd6e281101251bee55d220f7ad2a
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/nats/postunpack.sh
ENV APP_VERSION="2.8.0" \
    BITNAMI_APP_NAME="nats" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/nats/bin:$PATH"

EXPOSE 4222 6222 8222

WORKDIR /opt/bitnami/nats
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/nats/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/nats/run.sh" ]
