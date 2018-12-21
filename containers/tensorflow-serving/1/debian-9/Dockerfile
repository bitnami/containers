FROM bitnami/minideb-extras:stretch-r229
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6
RUN bitnami-pkg unpack tensorflow-serving-1.12.0-22 --checksum a89637c765ed0ccfa89e3f37b5e993764370fe3d6da4fde450c5e3b767d908a7

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-serving" \
    BITNAMI_IMAGE_VERSION="1.12.0-debian-9-r47" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/bazel-bin/tensorflow_serving/model_servers:$PATH" \
    TENSORFLOW_SERVING_MODEL_NAME="inception" \
    TENSORFLOW_SERVING_PORT_NUMBER="8500" \
    TENSORFLOW_SERVING_REST_API_PORT_NUMBER="8501"

EXPOSE 8500

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
