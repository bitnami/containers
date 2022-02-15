FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl docker git gzip jq procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kubectl" "1.23.3-1" --checksum a41dbb98e5d60a730a7d6ff56f574206fbb58add8de4bfc946afd366ef5f52e2
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-workflow-exec" "3.2.8-1" --checksum 0b429cade3bc84e9103b8429e799924f333b3eb37a352e083cffcdd9949887a2
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY rootfs /
RUN /opt/bitnami/scripts/argo-workflow-exec/postunpack.sh
ENV BITNAMI_APP_NAME="argo-workflow-exec" \
    BITNAMI_IMAGE_VERSION="3.2.8-debian-10-r10" \
    PATH="/opt/bitnami/kubectl/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-workflow-exec/bin:/opt/bitnami/argo-workflow-exec/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/argo-workflow-exec/bin/argoexec" ]
CMD [ "help" ]
