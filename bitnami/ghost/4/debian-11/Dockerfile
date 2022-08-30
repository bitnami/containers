FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="4.48.2-debian-11-r26" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/ghost" \
      org.opencontainers.image.title="ghost" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="4.48.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libaudit1 libbz2-1.0 libc6 libcap-ng0 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libicu67 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncurses6 libncursesw6 libnsl2 libpam0g libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 libxml2 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-166" --checksum 9a5fba755f6c8d60eacc80f366f3fbaa57d003913e48c31ba337037bb69e37b3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.20.0-3" --checksum 49946e0443d8f479f296c79589fea205126b6f6faa6b4474e5dd713b36d8167c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mysql-client" "10.6.9-1" --checksum 14ae2f6d8d5f4e3a9e4cf62d5a3da80587a20651a5920dbc4ac89afdaf06f8c0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ghost" "4.48.2-6" --checksum e0720edf203d54b786177278e9caf6fd92080632ef32b150ae0d41146841bf36
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/ghost/postunpack.sh
RUN /opt/bitnami/scripts/mysql-client/postunpack.sh
ENV APP_VERSION="4.48.2" \
    BITNAMI_APP_NAME="ghost" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mysql/bin:/opt/bitnami/common/bin:/opt/bitnami/ghost/bin:$PATH"

EXPOSE 2368 3000

WORKDIR /opt/bitnami/ghost
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/ghost/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/ghost/run.sh" ]
