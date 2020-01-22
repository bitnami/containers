FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl ghostscript imagemagick libc6 libgcc1 libgmp-dev libjemalloc-dev libncurses5 libncurses5-dev libreadline-dev libreadline7 libssl1.0.2 libstdc++6 libtinfo5 libxml2-dev libxslt1-dev procps sudo unzip wget zlib1g zlib1g-dev
RUN . ./libcomponent.sh && component_unpack "ruby" "2.6.5-0" --checksum 3a856a4569b5d4f59628209a1ab1b78619647bf1f4d5f11ca3ae6b28ee1e7fa9
RUN . ./libcomponent.sh && component_unpack "fluentd" "1.9.0-0" --checksum 1a74322551d4fd5ad491dc3581c7dd8d364814e9ab223c2fe9158448a991ddbf
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.9.0-debian-9-r0" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
