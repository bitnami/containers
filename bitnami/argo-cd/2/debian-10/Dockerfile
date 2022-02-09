FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 openssh-server procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kustomize" "4.5.1-0" --checksum 785513667bd5d6eb97514b876edfa3577b9effd665611f3a759aedf448fedaed
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ksonnet" "0.13.1-3" --checksum 2764f6ab96b61568479aab176d326e2f0e66a914662f165b77630a66be3bacaf
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "helm" "3.8.0-0" --checksum 3377b554cbd3461aa0213d3bfc4da04f89fa0068388ef9b39651a6c31a311fd9
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-3" --checksum 276ab5a0be4b05e136ec468d62c8f9cc4f40d9664c55f01f16a9f1209ba16980
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-cd" "2.2.5-0" --checksum 87d8143bc6fdc035a5b88d9b61bdc9987023f42b29b35bbb930568bccb42937e
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV BITNAMI_APP_NAME="argo-cd" \
    BITNAMI_IMAGE_VERSION="2.2.5-debian-10-r4" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="argocd" \
    NSS_WRAPPER_GROUP="/opt/bitnami/argo-cd/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/argo-cd/nss_passwd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "--help" ]
