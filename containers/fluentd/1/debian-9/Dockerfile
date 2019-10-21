FROM bitnami/minideb-extras-base:stretch-r377
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-9" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages ca-certificates ghostscript imagemagick libc6 libgcc1 libgmp-dev libjemalloc-dev libncurses5 libncurses5-dev libreadline-dev libreadline7 libssl1.0.2 libstdc++6 libtinfo5 libxml2-dev libxslt1-dev wget zlib1g zlib1g-dev
RUN . ./libcomponent.sh && component_unpack "ruby" "2.6.5-0" --checksum 3a856a4569b5d4f59628209a1ab1b78619647bf1f4d5f11ca3ae6b28ee1e7fa9
RUN . ./libcomponent.sh && component_unpack "fluentd" "1.7.3-0" --checksum 75dcded4cd13c60db4e73d44f034bf66497fa788c89d369d0f82c01312a00be7

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="fluentd" \
    BITNAMI_IMAGE_VERSION="1.7.3-debian-9-r16" \
    GEM_HOME="/opt/bitnami/fluentd" \
    PATH="/opt/bitnami/ruby/bin:/opt/bitnami/fluentd/bin:$PATH"

EXPOSE 24224 5140

WORKDIR /opt/bitnami/fluentd
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
