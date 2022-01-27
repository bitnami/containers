FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/serving/bazel-bin/tensorflow_serving/model_servers:/opt/bitnami/common/bin:$PATH"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gcc-7 gzip libc6 libgcc1 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tensorflow-serving" "2.7.0-3" --checksum 3e342a35930575e697717acaf023d7cdaa73f79c78fb2de176e6f327ee3d8814
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-6" --checksum 81b0642a6d8e9d952a0f6540f2d7481a99b9a12dd42bcb5906ba8014ca80f326
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/tensorflow-serving/postunpack.sh
ENV BITNAMI_APP_NAME="tensorflow-serving" \
    BITNAMI_IMAGE_VERSION="2.7.0-debian-10-r79" \
    JAVA_HOME="/opt/bitnami/java"

EXPOSE 8500

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tensorflow-serving/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tensorflow-serving/run.sh" ]
