FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/serving/bazel-bin/tensorflow_serving/model_servers:/opt/bitnami/common/bin:$PATH"

ARG JAVA_EXTRA_SECURITY_DIR="/bitnami/java/extra-security"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gcc-10 gzip libc6 libgcc-s1 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tensorflow-serving" "2.9.1-0" --checksum 721ee355a11b2eb2e2e7e0e079bf9f200b835089d068563f65d3d55a52ec2937
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.3-150" --checksum 8b992a5ee513c5eaca52b19232b21a93588ddf4c4850be4d47c6f19b11d1d90a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
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
