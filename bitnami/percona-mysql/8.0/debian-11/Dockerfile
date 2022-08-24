FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.0.29-21-debian-11-r5" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/percona-mysql" \
      org.opencontainers.image.title="percona-mysql" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.0.29-21"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libaudit1 libbrotli1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libcurl4 libev4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle8 libnghttp2-14 libnuma-dev libp11-kit0 libpam0g libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libudev1 libunistring2 libuuid1 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "percona-xtrabackup-binary" "8.0.29-22-0" --checksum aa23284e1bea5befa0cc015f440d9fb6556a3da905a277a0e3f1d51e86bc3a0e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.3-152" --checksum 0017b950b7eb0faa7580ef23342adbbfa2038d55c3dafdf1c8761788122f718e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "percona-mysql" "8.0.29-21-0" --checksum 30e3cd39f61751328c3d9bc5c3309e5c7a65bd11e4768fcbb0804687fa6015f1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-shell" "8.0.30-0" --checksum 1e71d5c92968af791c818070e4d5e37d67cd2159f92ceba32ec070dfe422d924
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mysql/postunpack.sh
ENV APP_VERSION="8.0.29-21" \
    BITNAMI_APP_NAME="percona-mysql" \
    MYSQL_HOME="/opt/bitnami/mysql/conf" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mysql/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mysql/run.sh" ]
