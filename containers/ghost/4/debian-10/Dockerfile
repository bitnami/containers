FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libaudit1 libbz2-1.0 libc6 libcap-ng0 libffi6 libgcc1 libicu63 libjemalloc2 liblzma5 libncurses6 libncursesw6 libpam0g libreadline7 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libxml2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-2" --checksum 704fe6b545280ae027303b4ec875b495ee6da2256b3d8f877467077b0f031a60
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.1-0" --checksum 806082b15c0eb60e4baca497519b4c0cc9cd636d7a944e9943ebc1b9632fabdc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.3.34-4" --checksum bb0089c26028b568dbe8b8875d39cca3c7835c582dda4fcbdcbed599320c57fe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ghost" "4.41.3-0" --checksum 41aef4493879786a5f1a478536b53993f64dd98c1ad1f2ebafa039d0ae8389a7
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/ghost/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV APP_VERSION="4.41.3" \
    BITNAMI_APP_NAME="ghost" \
    BITNAMI_IMAGE_VERSION="4.41.3-debian-10-r5" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/ghost/bin:$PATH"

EXPOSE 2368 3000

WORKDIR /opt/bitnami/ghost
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/ghost/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/ghost/run.sh" ]
