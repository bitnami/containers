FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="9.0.0-debian-11-r30" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/solr" \
      org.opencontainers.image.title="solr" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="9.0.0"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 lsof netcat-traditional procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-2" --checksum 1a5468c7b552dfc8a33c5c9b214dbf7dd143a5f008cc3aa2e0418fab5eb16c5c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "solr" "9.0.0-152" --checksum 37ff6cc71e3fe001b05249244111abe6ca5e08bb687d4002142ab3e16e5f6224
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/solr/postunpack.sh
ENV APP_VERSION="9.0.0" \
    BITNAMI_APP_NAME="solr" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:/opt/bitnami/solr/contrib/prometheus-exporter/bin:/opt/bitnami/solr/prometheus-exporter/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/solr/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/solr/run.sh" ]
