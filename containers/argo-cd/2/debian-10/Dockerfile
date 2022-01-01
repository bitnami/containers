FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 openssh-server procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kustomize" "4.4.1-0" --checksum f6a639078fe19a9c38ae9fc9904106172047aea73df04b69a2cc84f16e44035b
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ksonnet" "0.13.1-0" --checksum d789f0ddb6cf2351ba09ca3e907ea2e41605067f398aa8fa069bdcfe59a25cd6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "helm" "3.7.2-0" --checksum 061224e6c20ae4405b022e748fadc0ac9d537e1905162e9cb8f463ad3eb4820a
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-cd" "2.2.1-0" --checksum dfcc989450c20c0242751122455482a5bc481604310b20ce9a44de65600d5543
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV BITNAMI_APP_NAME="argo-cd" \
    BITNAMI_IMAGE_VERSION="2.2.1-debian-10-r15" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="argocd" \
    NSS_WRAPPER_GROUP="/opt/bitnami/argo-cd/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/argo-cd/nss_passwd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "--help" ]
