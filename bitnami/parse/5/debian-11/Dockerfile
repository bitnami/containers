FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="5.2.4-debian-11-r20" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/parse" \
      org.opencontainers.image.title="parse" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="5.2.4"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip jq libbz2-1.0 libc6 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.8.13-166" --checksum 9a5fba755f6c8d60eacc80f366f3fbaa57d003913e48c31ba337037bb69e37b3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "node" "14.20.0-3" --checksum 49946e0443d8f479f296c79589fea205126b6f6faa6b4474e5dd713b36d8167c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "mongodb-shell" "1.5.4-2" --checksum 77e3526b982f5fc7160827d41d2fae83a4c3dd3c88dec6fa2b2ce4cbb0078ef8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "parse" "5.2.4-3" --checksum 9e753dc2f7cdba1ed6d9105dae0bfde60fbdc9ff65f1f16da3ddddcb5ca07717
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-154" --checksum e36c3d90f4fbfbe989f40947fa7c8ab817f12fcf97d3aef893c753a20ce976ab
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/parse/postunpack.sh
ENV APP_VERSION="5.2.4" \
    BITNAMI_APP_NAME="parse" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/node/bin:/opt/bitnami/mongodb/bin:/opt/bitnami/parse/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 1337 3000

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/parse/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/parse/run.sh" ]
