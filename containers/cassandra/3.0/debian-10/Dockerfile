FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libgcc1 libjemalloc2 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "2.7.18-19" --checksum 5c1a62f69ce2bd0948098e52124be784bc9e5092afed2552e28f241b603eb709
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-2" --checksum b4d038090cda6aa243de5dc579a06d642918fbfc2473f114bdb443880e8a0d70
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.17.2-2" --checksum d4477fb9d29cf2cf450dcfc09da4db214d3435b6f4412b139bdddfbb20e8252d
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "cassandra" "3.0.25-4" --checksum dc8d86fe3c17282a7927651b0ddcaa2849607f103c02d4f0ea7afc20287279be
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/cassandra/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/cassandra/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/cassandra/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.0.25-debian-10-r107" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 7000 9042

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/cassandra/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/cassandra/run.sh" ]
