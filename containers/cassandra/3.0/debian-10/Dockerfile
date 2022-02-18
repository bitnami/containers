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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "2.7.18-23" --checksum 02d84add8b8aacf57eaa3207633960601d61870c38758b2658e4a4d964c24f5c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-7" --checksum 3ce0c1dc975421abe79ffa5d459b4562802312f299a86576d1a169fe2d38f5d9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-5" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.20.1-2" --checksum 5a5d183286140781203d11d468d4f84371c5808ee86471c7ee445f8d3cef0eb6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "cassandra" "3.0.26-2" --checksum 15b4a54c5a5cacb53b31b8c0f0eb20f715e587a3260dba566595ea3e403a729b
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/cassandra/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/cassandra/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/cassandra/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.0.26-debian-10-r6" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 7000 9042

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/cassandra/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/cassandra/run.sh" ]
