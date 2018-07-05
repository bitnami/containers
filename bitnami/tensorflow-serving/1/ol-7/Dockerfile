FROM bitnami/oraclelinux-extras:7-r26
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glibc libgcc libstdc++
RUN bitnami-pkg unpack tensorflow-serving-1.8.0-0 --checksum 1130912ce156e3c54dd690ee53fea4241bd8885749506a11bd47f62206d7efc1

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-serving" \
    BITNAMI_IMAGE_VERSION="1.8.0-ol-7-r8" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/bazel-bin/tensorflow_serving/model_servers:$PATH" \
    TENSORFLOW_SERVING_MODEL_NAME="inception" \
    TENSORFLOW_SERVING_PORT_NUMBER="9000"

EXPOSE 9000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["/run.sh"]
