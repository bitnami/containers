FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl libc6 procps sudo unzip
RUN . ./libcomponent.sh && component_unpack "yq" "3.1.2-1" --checksum 67e78565f5b1ea61d8ed588cc5f8681db6991e38ba1ac9509c3c0f53c25b0c10
RUN . ./libcomponent.sh && component_unpack "harbor-jobservice" "1.10.1-0" --checksum f8c1fe4a7804dad49ed53867bb299346966b458ef6adf00d30b9e2b69b23dd5f
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="harbor-jobservice" \
    BITNAMI_IMAGE_VERSION="1.10.1-debian-10-r13" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/common/bin:/opt/bitnami/harbor-jobservice/bin:$PATH"

VOLUME [ "/etc/jobservice", "/var/log/jobs/" ]

EXPOSE 8080 8443

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
