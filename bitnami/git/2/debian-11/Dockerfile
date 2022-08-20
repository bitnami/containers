FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.37.2-debian-11-r3" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/git" \
      org.opencontainers.image.title="git" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.37.2"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbrotli1 libc6 libcom-err2 libcurl4 libffi7 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle8 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 procps ssh tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "git" "2.37.2-0" --checksum e695c1e29ff39cd54da23d2d5c3703d7d767a1d17d42ca85b3581d6e2d171bca
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
ENV APP_VERSION="2.37.2" \
    BITNAMI_APP_NAME="git" \
    NSS_WRAPPER_LIB="/opt/bitnami/common/lib/libnss_wrapper.so" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/git/bin:$PATH"

ENTRYPOINT [ "/opt/bitnami/scripts/git/entrypoint.sh" ]
CMD [ "/bin/bash" ]
