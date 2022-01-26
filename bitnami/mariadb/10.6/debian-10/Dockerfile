FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libaudit1 libc6 libcap-ng0 libgcc1 libicu63 liblzma5 libncurses6 libpam0g libssl1.1 libstdc++6 libtinfo6 libxml2 procps psmisc tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.1-3" --checksum 26f2ba99a02266d6f3857a3a11db7ed441d76a2fbc1066a17d4b0b17b047e01d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mariadb" "10.6.5-3" --checksum 4bffa65e58d1d19d11184521fa2c160e84a707fd1bf91ec2798c4e34651f623f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mariadb/postunpack.sh
ENV BITNAMI_APP_NAME="mariadb" \
    BITNAMI_IMAGE_VERSION="10.6.5-debian-10-r73" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mariadb/bin:/opt/bitnami/mariadb/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mariadb/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mariadb/run.sh" ]
