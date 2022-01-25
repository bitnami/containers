FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/elasticsearch/bin:$PATH"

ARG ELASTICSEARCH_PLUGINS=""
ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip hostname libc6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.17.2-0" --checksum e44965c2d2878443baa6c21214be5ce416a0ba34aaa3b23127ceb3aaefc72b4a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.14-0" --checksum f7addf88d61b35543dc6ed9f5ec31fd8a800cec6249d419310fd56e8e9a3499d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "elasticsearch" "7.10.2-8" --checksum ac9d58c0c2f5a9c7c79610d0ca704fbbb139da3af5aaef0bdf66560509c77924
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/elasticsearch/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="elasticsearch" \
    BITNAMI_IMAGE_VERSION="7.10.2-debian-10-r342" \
    JAVA_HOME="/opt/bitnami/java" \
    LD_LIBRARY_PATH="/opt/bitnami/elasticsearch/jdk/lib:/opt/bitnami/elasticsearch/jdk/lib/server:$LD_LIBRARY_PATH"

EXPOSE 9200 9300

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/elasticsearch/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/elasticsearch/run.sh" ]
