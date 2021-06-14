FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/tensorflow-serving/bin:/opt/bitnami/tensorflow-serving/serving/bazel-bin/tensorflow_serving/model_servers:/opt/bitnami/common/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gcc-7 gzip libc6 libgcc1 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "tensorflow-serving" "2.5.1-0" --checksum ed90c212853aae73963b92d8d60ea5cb6be99d63283990cab385da214946fe74
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "render-template" "1.0.0-3" --checksum 8179ad1371c9a7d897fe3b1bf53bbe763f94edafef19acad2498dd48b3674efe
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.13.0-0" --checksum fd7257c2736164d02832dbf72e2c1ed9d875bf3e32f0988520796bc503330129
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/tensorflow-serving/postunpack.sh
ENV BITNAMI_APP_NAME="tensorflow-serving" \
    BITNAMI_IMAGE_VERSION="2.5.1-debian-10-r20" \
    TENSORFLOW_SERVING_ENABLE_MONITORING="no" \
    TENSORFLOW_SERVING_MODEL_NAME="resnet" \
    TENSORFLOW_SERVING_MONITORING_PATH="/monitoring/prometheus/metrics" \
    TENSORFLOW_SERVING_PORT_NUMBER="8500" \
    TENSORFLOW_SERVING_REST_API_PORT_NUMBER="8501"

EXPOSE 8500

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/tensorflow-serving/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/tensorflow-serving/run.sh" ]
