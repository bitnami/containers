FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 lsof netcat-traditional procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.15-1-1" --checksum 6d176a8b3c894c608106fee2cf10aaf3771015defb0b7e08fe60ce6c9c1cd342
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "solr" "8.11.2-1" --checksum 029e3bcf923251231ade79257d7784335afeb2213ab03449147a1aaa35cc32b5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/solr/postunpack.sh
ENV APP_VERSION="8.11.2" \
    BITNAMI_APP_NAME="solr" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:/opt/bitnami/solr/contrib/prometheus-exporter/bin:/opt/bitnami/solr/prometheus-exporter/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/solr/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/solr/run.sh" ]
