FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl docker git gzip jq procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kubectl" "1.23.1-0" --checksum fa7caa12251c51b8d8eac9d4f35182ec76f3868b4ad9c49e33a1a36bc54d2889
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-workflow-exec" "3.2.4-0" --checksum 3cad893d0b121947299c68b3d3af395e7488ba213ab81abb9a2a1affa4515c30

COPY rootfs /
RUN /opt/bitnami/scripts/argo-workflow-exec/postunpack.sh
ENV BITNAMI_APP_NAME="argo-workflow-exec" \
    BITNAMI_IMAGE_VERSION="3.2.4-debian-10-r31" \
    PATH="/opt/bitnami/kubectl/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-workflow-exec/bin:/opt/bitnami/argo-workflow-exec/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/argo-workflow-exec/bin/argoexec" ]
CMD [ "help" ]
