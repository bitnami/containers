FROM bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl ghostscript imagemagick libc6 libgcc1 libgmp-dev libjemalloc-dev libncurses5-dev libncurses6 libreadline-dev libreadline7 libssl1.1 libstdc++6 libtinfo6 libxml2-dev libxslt1-dev procps sudo unzip wget zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.5-1" --checksum 99d4bc115bd1f2ce13a76e16359f03acef2ceccfc5468f1b008e9ea9d07dc7fc
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.11.0-3" --checksum c18bb8bcc95aa2494793ed5a506c4d03acc82c8c60ad061d5702e0b4048f0cb1
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "fluentd" "1.9.3-0" --checksum d76f66dab66b15389eb046b9c654297eb6704217bb4653dd5488e03fd99a1731
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN useradd -r -u 1001 -g root fluentd

COPY rootfs /
RUN /opt/bitnami/scripts/fluentd/postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.9.3-debian-10-r8" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/common/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/fluentd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/fluentd/run.sh" ]
