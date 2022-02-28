FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libffi6 libgcc1 libjemalloc2 liblzma5 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "3.9.10-24" --checksum 7269fd86b2c69677c3856c2de9b4f9cec3ce92204168243da1b77b8f9c12acaa
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.322-7" --checksum 3ce0c1dc975421abe79ffa5d459b4562802312f299a86576d1a169fe2d38f5d9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.21.1-0" --checksum 4a2289448b8cfe68482c1316d901a1f68692194085b6f0b05c64538bdf3858f8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "cassandra" "4.0.3-1" --checksum c7848a2d710fca8ff0a769d979d29b5f7bf6447431c6a5d79297b200959949ce
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/cassandra/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/cassandra/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/cassandra/postunpack.sh
RUN /opt/bitnami/scripts/java/postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="4.0.3-debian-10-r9" \
    JAVA_HOME="/opt/bitnami/java" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 7000 9042

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/cassandra/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/cassandra/run.sh" ]
