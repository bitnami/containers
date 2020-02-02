FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl ghostscript imagemagick libc6 libgcc1 libgmp-dev libjemalloc-dev libncurses5-dev libncurses6 libreadline-dev libreadline7 libssl1.1 libstdc++6 libtinfo6 libxml2-dev libxslt1-dev procps sudo unzip wget zlib1g zlib1g-dev
RUN . ./libcomponent.sh && component_unpack "ruby" "2.6.5-1" --checksum 99d4bc115bd1f2ce13a76e16359f03acef2ceccfc5468f1b008e9ea9d07dc7fc
RUN . ./libcomponent.sh && component_unpack "fluentd" "1.9.1-0" --checksum 950a299a2943ed6d3d52aee934b1037d40f0b1deca8b0405bea528f5adad21e5
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.9.1-debian-10-r1" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
