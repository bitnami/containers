FROM docker.io/bitnami/minideb:bullseye

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
ARG TARGETARCH

LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.ref.name="3.3.1-debian-11-r29" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/spark" \
      org.opencontainers.image.title="spark" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="3.3.1"

ENV HOME="/" \
    OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/spark/bin:/opt/bitnami/spark/sbin:/opt/bitnami/common/bin:$PATH"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libbz2-1.0 libcom-err2 libcrypt1 libffi7 libgcc-s1 libgssapi-krb5-2 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 liblzma5 libncursesw6 libnsl2 libreadline8 libsqlite3-0 libssl1.1 libstdc++6 libtinfo6 libtirpc3 procps zlib1g
RUN mkdir -p /tmp/bitnami/pkg/cache/ && cd /tmp/bitnami/pkg/cache/ && \
    COMPONENTS=( \
      "python-3.8.16-0-linux-${OS_ARCH}-debian-11" \
      "java-1.8.352-2-linux-${OS_ARCH}-debian-11" \
      "spark-3.3.1-3-linux-${OS_ARCH}-debian-11" \
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
RUN /opt/bitnami/scripts/spark/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV APP_VERSION="3.3.1" \
    BITNAMI_APP_NAME="spark" \
    JAVA_HOME="/opt/bitnami/java" \
    LD_LIBRARY_PATH="/opt/bitnami/python/lib/:/opt/bitnami/spark/venv/lib/python3.8/site-packages/numpy.libs/:$LD_LIBRARY_PATH" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    NSS_WRAPPER_GROUP="/opt/bitnami/spark/tmp/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/spark/tmp/nss_passwd" \
    PYTHONPATH="/opt/bitnami/spark/python/:$PYTHONPATH" \
    SPARK_HOME="/opt/bitnami/spark"

WORKDIR /opt/bitnami/spark
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/spark/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spark/run.sh" ]
