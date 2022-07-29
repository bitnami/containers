FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kustomize" "4.5.6-0" --checksum 16c565a0527f60dc812f71ac20ddea07d0c2f8673c2f678ad6b5d125b15ca37b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ksonnet" "0.13.1-151" --checksum aae808c3b053381c23ca11ce24303a489129ff509c827f25e1ba4fce2797bb40
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "helm" "3.9.2-0" --checksum 48618accb2aad08762e8b5aadbe66f4a63fa449467038ed8629958ecf8f420db
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-152" --checksum 0c751c7e2ec0bc900a19dbec0306d6294fe744ddfb0fa64197ba1a36040092f0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-cd" "2.4.8-0" --checksum ca24c8196dace1244a2a1f02a3768ee7fc6b2a9d04eaf18ace6ac975f8d78866
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV APP_VERSION="2.4.8" \
    BITNAMI_APP_NAME="argo-cd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "argocd", "--help" ]
