FROM docker.io/bitnami/minideb:bullseye

ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="1.3.1-debian-11-r24" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/gramine-redis-intel" \
      org.opencontainers.image.title="gramine-redis-intel" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="1.3.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages binutils ca-certificates curl libbrotli1 libbz2-1.0 libcom-err2 libcrypt1 libcurl4 libffi7 libgcc-s1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed6 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncursesw6 libnettle8 libnghttp2-14 libnsl2 libp11-kit0 libprotobuf-c1 libpsl5 libreadline8 librtmp1 libsasl2-2 libsqlite3-0 libssh2-1 libssl1.1 libstdc++6 libtasn1-6 libtinfo6 libtirpc3 libunistring2 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "redis-7.0.7-0-linux-${OS_ARCH}-debian-11" \
      "python-3.10.9-0-linux-${OS_ARCH}-debian-11" \
      "gramine-redis-intel-1.3.1-0-linux-${OS_ARCH}-debian-11" \
      "gosu-1.16.0-0-linux-${OS_ARCH}-debian-11" \
    ) && \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi && \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" && \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' && \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done
RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.local && chmod g+rwX /.local

COPY rootfs /
RUN /opt/bitnami/scripts/gramine-redis-intel/postunpack.sh
ENV APP_VERSION="1.3.1" \
    BITNAMI_APP_NAME="gramine-redis-intel" \
    LD_LIBRARY_PATH="/opt/bitnami/gramine-intel/lib/x86_64-linux-gnu:/opt/bitnami/gramine-intel/lib/x86_64-linux-gnu/gramine/sgx:$LD_LIBRARY_PATH" \
    PATH="/opt/bitnami/redis/bin:/opt/bitnami/python/bin:/opt/bitnami/gramine-redis-intel/bin:/opt/bitnami/common/bin:/opt/bitnami/gramine-intel/bin:$PATH"

EXPOSE 6379

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/gramine-redis-intel/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/gramine-redis-intel/run.sh" ]
