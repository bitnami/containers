FROM docker.io/bitnami/minideb:bullseye
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libicu67 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncurses6 libncursesw6 libnsl2 libpam0g libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 libxml2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-2" --checksum 79af9dcbaa89c4047d2d24b4a4c2ae17b771fe94972734379b9e50ef3dec3442
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.19.3-0" --checksum 97cffecfb637e5758197e4eb14d50b42048768eba242da4b534f1d8bacbd6958
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.8-0" --checksum b47e1015fc1c9ce456f134ffd5b6ac6960c3f369c96fcd37319e9289b29a1047
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum da4a2f759ccc57c100d795b71ab297f48b31c4dd7578d773d963bbd49c42bd7b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ghost" "5.2.2-0" --checksum 65a3b8eb33ed2997c05099a45cc013c9a956605bcd1f630649b01b5f4129d16f
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/ghost/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV APP_VERSION="5.2.2" \
    BITNAMI_APP_NAME="ghost" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/ghost/bin:$PATH"

EXPOSE 2368 3000

WORKDIR /opt/bitnami/ghost
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/ghost/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/ghost/run.sh" ]
