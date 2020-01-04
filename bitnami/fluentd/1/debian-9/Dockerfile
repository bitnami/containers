FROM bitnami/minideb:stretch
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl ghostscript imagemagick libc6 libgcc1 libgmp-dev libjemalloc-dev libncurses5 libncurses5-dev libreadline-dev libreadline7 libssl1.0.2 libstdc++6 libtinfo5 libxml2-dev libxslt1-dev procps unzip wget zlib1g zlib1g-dev
RUN . ./libcomponent.sh && component_unpack "ruby" "2.6.5-0" --checksum 3a856a4569b5d4f59628209a1ab1b78619647bf1f4d5f11ca3ae6b28ee1e7fa9
RUN . ./libcomponent.sh && component_unpack "fluentd" "1.8.1-0" --checksum f099afb12e8a27968be6cfced353b810affa083f22b68e581a863f68b66ccf8d
RUN apt-get update && apt-get upgrade && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN curl --silent -L https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64 > /usr/local/bin/gosu && \
    echo 0b843df6d86e270c5b0f5cbd3c326a04e18f4b7f9b8457fa497b0454c4b138d7 /usr/local/bin/gosu | sha256sum --check && \
    chmod u+x /usr/local/bin/gosu && \
    mkdir -p /opt/bitnami/licenses && \
    curl --silent -L https://raw.githubusercontent.com/tianon/gosu/master/LICENSE > /opt/bitnami/licenses/gosu-1.11.txt

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.8.1-debian-9-r7" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
