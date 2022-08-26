FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/serving/bazel-bin/tensorflow_serving/model_servers:/opt/bitnami/common/bin:$PATH"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"
LABEL org.opencontainers.image.authors="https://bitnami.com/contact" \
      org.opencontainers.image.description="Application packaged by Bitnami" \
      org.opencontainers.image.ref.name="2.9.1-debian-11-r17" \
      org.opencontainers.image.source="https://github.com/bitnami/containers/tree/main/bitnami/tensorflow-serving" \
      org.opencontainers.image.title="tensorflow-serving" \
      org.opencontainers.image.vendor="VMware, Inc." \
      org.opencontainers.image.version="2.9.1"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gcc-10 gzip libc6 libgcc-s1 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tensorflow-serving" "2.9.1-2" --checksum 65be71547a0e7b4cbc1a983ecf9a5658a07f065d42adae0dc653ce5a45b24c91
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-152" --checksum 7909504f3232654c427681ecc8ed4b8599a2df0f17f26ff769a83ed167d05b69
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-153" --checksum d3ae0109be24e8bc56f97359b8290b91243454de946dd60bd8520a0896a88449
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/tensorflow-serving/postunpack.sh
ENV APP_VERSION="2.9.1" \
    BITNAMI_APP_NAME="tensorflow-serving" \
    JAVA_HOME="/opt/bitnami/java"

EXPOSE 8500

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tensorflow-serving/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tensorflow-serving/run.sh" ]
