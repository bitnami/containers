FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libaio1 libc6 libgcc1 libncurses6 libsasl2-2 libssl1.1 libstdc++6 libtinfo6 procps sudo unzip zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql" "8.0.19-0" --checksum 244719d8d5037bd8c919bc011f0d62b3bebf2783d2705bae56d8e312736cfebc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mysql/postunpack.sh
ENV BITNAMI_APP_NAME="mysql" \
    BITNAMI_IMAGE_VERSION="8.0.19-debian-10-r62" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:/opt/bitnami/common/bin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mysql/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mysql/run.sh" ]
