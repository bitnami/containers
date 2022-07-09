FROM docker.io/bitnami/minideb:bullseye
ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl docker git gzip jq procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kubectl" "1.23.8-1" --checksum 00118c76ca3b2b01eaa304b43b7ed07ef9c300844118f0490d4c34442f77efe2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-workflow-exec" "3.3.8-0" --checksum ca62031e2ac9008883030e39de9778a28d8a54bb35d16a1acb13cce47de23174
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/argo-workflow-exec/postunpack.sh
ENV APP_VERSION="3.3.8" \
    BITNAMI_APP_NAME="argo-workflow-exec" \
    PATH="/opt/bitnami/kubectl/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-workflow-exec/bin:/opt/bitnami/argo-workflow-exec/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/argo-workflow-exec/bin/argoexec" ]
CMD [ "help" ]
