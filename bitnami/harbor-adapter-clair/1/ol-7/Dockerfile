FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl gzip hostname libaio-devel procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "harbor-adapter-clair" "1.0.1-0" --checksum f84ec9edc6e0be1c3008267f81b0e6fa9ceaed2dfec784d9b69ec9d13a2106c2
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="harbor-adapter-clair" \
    BITNAMI_IMAGE_VERSION="1.0.1-ol-7-r11" \
    PATH="/opt/bitnami/harbor-adapter-clair/bin:$PATH"

EXPOSE 8080

WORKDIR /opt/bitnami/harbor-adapter-clair
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
