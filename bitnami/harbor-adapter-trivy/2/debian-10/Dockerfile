FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl gzip libc6 procps rpm tar
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "harbor-adapter-trivy" "2.4.1-2" --checksum 5df5682201be70abce32c8759787db6e35b01158c8f065c90a57495b50f80075
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.14.0-1" --checksum 16f1a317859b06ae82e816b30f98f28b4707d18fe6cc3881bff535192a7715dc
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/harbor-adapter-trivy/postunpack.sh
ENV BITNAMI_APP_NAME="harbor-adapter-trivy" \
    BITNAMI_IMAGE_VERSION="2.4.1-debian-10-r24" \
    PATH="/opt/bitnami/harbor-adapter-trivy/bin:/opt/bitnami/common/bin:$PATH"

WORKDIR /opt/bitnami/harbor-adapter-trivy
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/harbor-adapter-trivy/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/harbor-adapter-trivy/run.sh" ]
