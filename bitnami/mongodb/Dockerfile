FROM gcr.io/stacksmith-images/minideb:jessie-r5
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=3.4.0-r0 \
    BITNAMI_APP_NAME=mongodb \
    BITNAMI_APP_USER=mongo

# System packages required
RUN install_packages libssl1.0.0 libc6 libgcc1 libpcap0.8

# Install mongodb
RUN bitnami-pkg unpack mongodb-3.4.0-0 --checksum d7e82734ab32622c064d13d3ac1d56809f0981c854da6d0495f64779f3ebedae

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/sbin:/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "mongodb"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 27017
