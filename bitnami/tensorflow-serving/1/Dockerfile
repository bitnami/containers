FROM bitnami/minideb-extras:jessie-r28
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6
RUN bitnami-pkg unpack tensorflow-serving-1.6.0-0 --checksum 22a0be55c39176f1ceface93112c51ec5b3a10aad304db72bc71d6d98794bbbc

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-serving" \
    BITNAMI_IMAGE_VERSION="1.6.0-r2" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/bazel-bin/tensorflow_serving/model_servers:$PATH" \
    TENSORFLOW_SERVING_MODEL_NAME="inception" \
    TENSORFLOW_SERVING_PORT_NUMBER="9000"

EXPOSE 9000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
