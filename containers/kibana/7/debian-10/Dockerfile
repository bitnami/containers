FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/kibana/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 libexpat1 libgcc1 libnss3 libstdc++6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "yq" "4.19.1-0" --checksum fc3246374edb10a2d65df05c27187396ade8f91cb86e38b071704dcadde13802
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kibana" "7.17.0-0" --checksum caff3f9019c2a6eaaa8b9c396620dfdb99dc6a074f1d5952230531eba59d3b7d
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/kibana/postunpack.sh
ENV BITNAMI_APP_NAME="kibana" \
    BITNAMI_IMAGE_VERSION="7.17.0-debian-10-r3"

EXPOSE 5601

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/kibana/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/kibana/run.sh" ]
