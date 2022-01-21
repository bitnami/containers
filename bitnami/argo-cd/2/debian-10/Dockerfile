FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 openssh-server procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kustomize" "4.4.1-2" --checksum 49d095c2e7fab41f152aca81e03c166e168d87063148fa771e8b9033d852e441
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ksonnet" "0.13.1-2" --checksum 4c855d79eea3d669c11d89689fae9b396113015b06d9b04da0570b05ec619705
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "helm" "3.7.2-2" --checksum 52a40c9ca04c0c005a28cd689b142f65b5739606cb8e536fa92b0f3be6298e81
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-2" --checksum 7419bc5e2be68eb14c92e321acc843413481cda73323fb8c0d1dda8b1e5aa9d5
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-cd" "2.2.3-1" --checksum 15e2e2758cb367d5bd6a9f2a47a8a7b044b8756fb018e5517ada0b27d73fc56c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV BITNAMI_APP_NAME="argo-cd" \
    BITNAMI_IMAGE_VERSION="2.2.3-debian-10-r4" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="argocd" \
    NSS_WRAPPER_GROUP="/opt/bitnami/argo-cd/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/argo-cd/nss_passwd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "--help" ]
