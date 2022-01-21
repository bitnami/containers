FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libevent-2.1-6 libsasl2-2 libsasl2-modules procps sasl2-bin tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "memcached" "1.6.13-1" --checksum 904fba522a5b6e388ec60736abd8bf863e756f9ff224fdf91914255359362cf4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/memcached/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/memcached/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/memcached/postunpack.sh
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.6.13-debian-10-r9" \
    PATH="/opt/bitnami/memcached/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/memcached/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/memcached/run.sh" ]
