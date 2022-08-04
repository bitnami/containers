FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libevent-2.1-7 libsasl2-2 libsasl2-modules procps sasl2-bin tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "memcached" "1.6.16-0" --checksum 39382cbac16620e6b0b205e640c6ad412ae7db7823869ea1ea5523c527fccd03
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/memcached/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/memcached/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/memcached/postunpack.sh
ENV APP_VERSION="1.6.16" \
    BITNAMI_APP_NAME="memcached" \
    PATH="/opt/bitnami/memcached/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/memcached/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/memcached/run.sh" ]
