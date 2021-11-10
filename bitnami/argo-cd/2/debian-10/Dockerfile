FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl git git-lfs gnupg gzip libc6 openssh-server procps tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "kustomize" "4.4.0-0" --checksum 2d20f6868608a998f5338b07c2c1730bcd6d64aecd53a65bf38b0706ab358a81
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ksonnet" "0.13.1-0" --checksum d789f0ddb6cf2351ba09ca3e907ea2e41605067f398aa8fa069bdcfe59a25cd6
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "helm" "3.7.1-0" --checksum 7246ce03375c72696c47dde2cbaa2c4caeade50ce7bb6dbe87ca7e6a2d54c156
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-0" --checksum 3e6fc37ca073b10a73a804d39c2f0c028947a1a596382a4f8ebe43dfbaa3a25e
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "argo-cd" "2.1.6-0" --checksum 9aea3f6911488cdbb1300efdfb7f83b304b2baee65e862d1acf8532950988166
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/argo-cd/postunpack.sh
ENV BITNAMI_APP_NAME="argo-cd" \
    BITNAMI_IMAGE_VERSION="2.1.6-debian-10-r11" \
    LIBNSS_WRAPPER_PATH="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="argocd" \
    NSS_WRAPPER_GROUP="/opt/bitnami/argo-cd/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/argo-cd/nss_passwd" \
    PATH="/opt/bitnami/kustomize/bin:/opt/bitnami/ksonnet/bin:/opt/bitnami/helm/bin:/opt/bitnami/common/bin:/opt/bitnami/argo-cd/bin:/opt/bitnami/argo-cd/hack:$PATH"

USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/argo-cd/entrypoint.sh" ]
CMD [ "--help" ]
