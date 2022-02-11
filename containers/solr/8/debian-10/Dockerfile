FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libgcc1 lsof netcat-traditional procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-5" --checksum 5bea54f21135133d1d0df7486e419d204f846d8acac4c83e1c6359a703fc9244
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "solr" "8.11.1-4" --checksum 2e61b013cd5976de40a53b04842e01ad18df65ee7d2b368952afd0d149690068
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/solr/postunpack.sh
ENV BITNAMI_APP_NAME="solr" \
    BITNAMI_IMAGE_VERSION="8.11.1-debian-10-r55" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/solr/bin:/opt/bitnami/common/bin:$PATH"

EXPOSE 8983

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/solr/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/solr/run.sh" ]
