FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 openssh-server procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kustomize" "4.5.2-1" --checksum 040f7cbcd104cc77ce163f419a6013f8b406f91d31c8efa1d0404aeed9c8abc3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ksonnet" "0.13.1-4" --checksum 3b610986535c1d353a57b9ae83560760e3f970b3c74c493ea3226769cc6216f4
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "helm" "3.8.0-1" --checksum 8a38c29be559d10367c1e5fdca9eeffe930a119275455ec2f010198de5d747c8
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-4" --checksum ec62006ece7e0b49c65926e458ba2b71d6d251552118b1378840b1803dbb3d53
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-cd" "2.2.5-1" --checksum e7d1709cace797a94f333c94669ebff041e729ef27b562e86d28e0423801f454
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV BITNAMI_APP_NAME="argo-cd" \
    BITNAMI_IMAGE_VERSION="2.2.5-debian-10-r5" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="argocd" \
    NSS_WRAPPER_GROUP="/opt/bitnami/argo-cd/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/argo-cd/nss_passwd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "--help" ]
