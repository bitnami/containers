FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/xgboost-intel" \
      org.opencontainers.image.title="xgboost-intel" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.6.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgomp1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.10.6-5" --checksum b5a9c05c7a8d88677c7cef6fb804f1902e30ca81e4aaa90da40931df038e7ca9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "xgboost-intel" "1.6.1-152" --checksum d280d1d9039e2cf08f1a3d410c4460055327ecd0012799d5081a0a9d8816319f
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.local && chmod g+rwX /.local

COPY rootfs /
RUN /opt/bitnami/scripts/xgboost-intel/postunpack.sh
ENV APP_VERSION="1.6.1" \
    BITNAMI_APP_NAME="xgboost-intel" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /app
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/xgboost-intel/entrypoint.sh" ]
CMD [ "python" ]
