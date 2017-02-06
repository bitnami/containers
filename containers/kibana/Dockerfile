FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=kibana \
    BITNAMI_IMAGE_VERSION=4.6.4-r0 \
    PATH=/opt/bitnami/kibana/bin:$PATH

# System packages required
RUN install_packages libc6 libstdc++6 libgcc1

# Install kibana
RUN bitnami-pkg unpack kibana-4.6.4-1 --checksum ed091cd7153a36c5e786c3c5ce09c10d8a68a027458ad1811da5a2a8275158a1

COPY rootfs /

VOLUME ["/bitnami/kibana"]

EXPOSE 5601

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "kibana"]
