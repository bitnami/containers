FROM bitnami/minideb-extras:stretch-r172
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libgcc1 libstdc++6
RUN bitnami-pkg unpack tensorflow-serving-1.11.0-1 --checksum 9e100a1284fa90f2748470d189326a70ba7500325fe70e6758a7a3bc7868b757

COPY rootfs /
ENV BITNAMI_APP_NAME="tensorflow-serving" \
    BITNAMI_IMAGE_VERSION="1.11.0-debian-9-r17" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/bazel-bin/tensorflow_serving/model_servers:$PATH" \
    TENSORFLOW_SERVING_MODEL_NAME="inception" \
    TENSORFLOW_SERVING_PORT_NUMBER="8500" \
    TENSORFLOW_SERVING_REST_API_PORT_NUMBER="8501"

EXPOSE 8500

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
