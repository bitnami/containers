FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 openssh-server procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kustomize" "4.5.4-0" --checksum 839883a4eb57d7bb3ab7cf274dd3cc30c621673c5288c24f6e99fb327fc73d6a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ksonnet" "0.13.1-7" --checksum d0add05910e38e57f69c2ed7bb208ba89a68867495ef0d40e40124b7a58c4ab0
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "helm" "3.8.2-0" --checksum 8b526fe787c357983604792fcc63eb607b59b811a1f4e81e2bcf323bddcd1f00
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-7" --checksum d6280b6f647a62bf6edc74dc8e526bfff63ddd8067dcb8540843f47203d9ccf1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-cd" "2.3.3-0" --checksum f722688e6a0e1948a04c20a144fcb878090943408ab4cc6e3d177e67f3ddf619
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV APP_VERSION="2.3.3" \
    BITNAMI_APP_NAME="argo-cd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "--help" ]
