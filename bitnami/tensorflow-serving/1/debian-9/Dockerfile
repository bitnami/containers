FROM bitnami/minideb-extras:stretch-r197
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6
RUN bitnami-pkg unpack tensorflow-serving-1.12.0-0 --checksum 81731facae4424efbf130fe2e368a8f015843d8f8ba8d9c6c5d7f2bb88e68cae

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-serving" \
    BITNAMI_IMAGE_VERSION="1.12.0-debian-9-r5" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/bazel-bin/tensorflow_serving/model_servers:$PATH" \
    TENSORFLOW_SERVING_MODEL_NAME="inception" \
    TENSORFLOW_SERVING_PORT_NUMBER="8500" \
    TENSORFLOW_SERVING_REST_API_PORT_NUMBER="8501"

EXPOSE 8500

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
