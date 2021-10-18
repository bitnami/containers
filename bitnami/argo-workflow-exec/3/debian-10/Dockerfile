FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl docker git gzip jq procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kubectl" "1.19.15-0" --checksum cfa18984f80f8ead7989ad4e2cc1001ba8feafce63d63f163ca785a0b48b43cb
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-workflow-exec" "3.2.0-0" --checksum 041222ad7f7b1a296358c9784fe7b85553397734d1085fb52e0364b7b787867d

COPY rootfs /
RUN /opt/bitnami/scripts/argo-workflow-exec/postunpack.sh
ENV BITNAMI_APP_NAME="argo-workflow-exec" \
    BITNAMI_IMAGE_VERSION="3.2.0-debian-10-r5" \
    PATH="/opt/bitnami/kubectl/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-workflow-exec/bin:/opt/bitnami/argo-workflow-exec/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/argo-workflow-exec/bin/argoexec" ]
CMD [ "help" ]
