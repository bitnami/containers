FROM docker.io/bitnami/minideb:bullseye
ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-11" \
    OS_NAME="linux"

COPY prebuildfs /
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 openssh-server procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kustomize" "4.5.5-150" --checksum 2c89fe0f7d8610b0f19ea030d5730e740d0ed553ebfae7b3b3437e48704d74d7
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ksonnet" "0.13.1-150" --checksum 0e608e49226f8e76f8f41b4178e5435129a35c221add67e7af2787b4c1b4c0f0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "helm" "3.9.1-0" --checksum b79c30144e10fa5804b3c62490e86b3acaba807a569561e66d6b49938fc515f4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-151" --checksum 089bb11a3bc6031c5a91ab5f9534e9e7e41b928d10d72a3986f16bb61d3a9900
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-cd" "2.4.6-0" --checksum cf6bd0b7a84798db3e900a83055c6942b9c227b53339c844a3bd7fd022e70342
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV APP_VERSION="2.4.6" \
    BITNAMI_APP_NAME="argo-cd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "argocd", "--help" ]
