FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="8.0.30-debian-11-r11" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/mysql" \
      org.opencontainers.image.title="mysql" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="8.0.30"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libaio1 libc6 libcom-err2 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libsasl2-2 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps psmisc tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ini-file" "1.4.3-152" --checksum 0017b950b7eb0faa7580ef23342adbbfa2038d55c3dafdf1c8761788122f718e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql" "8.0.30-1" --checksum b8434dd5d6061c7f5d23e8c6d9e953847f5ef25e09fa8d01693e1decb3037c8a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /docker-entrypoint-initdb.d

COPY rootfs /
RUN /opt/bitnami/scripts/mysql/postunpack.sh
ENV APP_VERSION="8.0.30" \
    BITNAMI_APP_NAME="mysql" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/mysql/bin:/opt/bitnami/mysql/sbin:$PATH"

EXPOSE 3306

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/mysql/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/mysql/run.sh" ]
