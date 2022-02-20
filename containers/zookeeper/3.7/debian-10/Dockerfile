FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/java/bin:/opt/bitnami/zookeeper/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 netcat procps tar zlib1g
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "wait-for-port" "1.0.1-9" --checksum 4b509978f6d0a4c3b958deeb3490241cda60e4412c138da665192631d60f70de
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "java" "11.0.14-6" --checksum 8e9d15dc54b3cf57e7f3b92efbb1e01ed07f002889034ec7703b62efb8265243
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "zookeeper" "3.7.0-10" --checksum 9336a9b2a2b0bbd04f1963a216e78855182c70ca165814cc7c23f23f38dc181f
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN ln -s /opt/bitnami/scripts/zookeeper/entrypoint.sh /entrypoint.sh
RUN ln -s /opt/bitnami/scripts/zookeeper/run.sh /run.sh

COPY rootfs /
RUN /opt/bitnami/scripts/zookeeper/postunpack.sh
ENV BITNAMI_APP_NAME="zookeeper" \
    BITNAMI_IMAGE_VERSION="3.7.0-debian-10-r298"

EXPOSE 2181 2888 3888 8080

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/zookeeper/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/zookeeper/run.sh" ]
