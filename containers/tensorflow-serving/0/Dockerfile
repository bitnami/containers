FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"



# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6
RUN bitnami-pkg unpack tensorflow-serving-0.6.0-0 --checksum 0b55d1bf8e0ee73ed742d38a5dc1d5bbbe4d17d388a199cd9c7ae5b0d9435380

COPY rootfs /

ENV BITNAMI_APP_NAME="tensorflow-serving" \
    BITNAMI_IMAGE_VERSION="0.6.0-r1" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/bazel-bin/tensorflow_serving/model_servers:$PATH" \
    TENSORFLOW_SERVING_MODEL_NAME="inception" \
    TENSORFLOW_SERVING_PORT_NUMBER="9000"




EXPOSE 9000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
