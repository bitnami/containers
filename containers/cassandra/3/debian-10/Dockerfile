FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libbz2-1.0 libc6 libgcc1 libjemalloc2 libncursesw6 libreadline7 libsqlite3-0 libssl1.1 libtinfo6 procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "python" "2.7.18-5" --checksum 9a73461139d612ceffc1b6f629e8c4b9041c34ebc2e0d56cd68565072ad0c70b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "1.8.265-0" --checksum 6c85e8df954fca444f2471195524db015ec24a67e42f43579401f2adb5189cb8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "3.3.2-0" --checksum 50cac57ffd984455e7321d1f13380f94b6bda2a16b7e2547ba33aad347d5e9eb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-1" --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "cassandra" "3.11.7-0" --checksum 3609d205da55b520c1f4bb3f88f23eaedab9f9a3efe9d0d0678ae0b2b0f75b2e
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/cassandra/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/cassandra/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/cassandra/postunpack.sh
ENV BITNAMI_APP_NAME="cassandra" \
    BITNAMI_IMAGE_VERSION="3.11.7-debian-10-r11" \
    PATH="/opt/bitnami/python/bin:/opt/bitnami/java/bin:/opt/bitnami/common/bin:/opt/bitnami/cassandra/bin:$PATH"

EXPOSE 7000 9042

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/cassandra/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/cassandra/run.sh" ]
