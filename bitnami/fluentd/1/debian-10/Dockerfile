FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages acl ca-certificates curl ghostscript gzip imagemagick libc6 libgcc1 libgmp-dev libjemalloc-dev libncurses5-dev libncurses6 libreadline-dev libreadline7 libssl1.1 libstdc++6 libtinfo6 libxml2-dev libxslt1-dev procps tar wget zlib1g zlib1g-dev
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "ruby" "2.6.6-0" --checksum ecadce77e40822926c69f76cc11437954dd068793548c3f0a21007f9c4fafed3
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "gosu" "1.12.0-1" --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN . /opt/bitnami/scripts/libcomponent.sh && component_unpack "fluentd" "1.11.1-3" --checksum 73315b23b637635c6f0e557062a7c5d0ecfd8aeb0cd2ab6104deed460d5dfb21
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami

COPY rootfs /
RUN /opt/bitnami/scripts/fluentd/postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.11.1-debian-10-r32" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/common/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 5140 24224

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/opt/bitnami/scripts/fluentd/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/fluentd/run.sh" ]
