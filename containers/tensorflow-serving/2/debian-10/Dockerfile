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
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tensorflow-serving" "2.8.0-3" --checksum 88798f7ef9579b09b4a3777b94aa9dc328e619807537ee7b45476714c4a3d738
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.1-9" --checksum 4694f01476c5a457a71f280562df45ea542bdf3f9b298ff87643a89ea365f5fb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-6" --checksum 6f8fd2267481ffbe899a7f93b7b3076cd78dd70b7b9835bed79414932a749664
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/java/postunpack.sh
RUN /opt/bitnami/scripts/tensorflow-serving/postunpack.sh
ENV BITNAMI_APP_NAME="tensorflow-serving" \
    BITNAMI_IMAGE_VERSION="2.8.0-debian-10-r7" \
    JAVA_HOME="/opt/bitnami/java"

EXPOSE 8500

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tensorflow-serving/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tensorflow-serving/run.sh" ]
