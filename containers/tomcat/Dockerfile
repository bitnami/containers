FROM gcr.io/stacksmith-images/minideb:jessie-r0

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=8.0.36-r1 \
    BITNAMI_APP_NAME=tomcat \
    BITNAMI_APP_USER=tomcat \
    PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/java/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_111-0 --checksum a40aa0c9553e13bd8ddcc3d2ba966492b79d4f73d47cb1499c9ec54f441201eb

# Install tomcat
RUN bitnami-pkg unpack tomcat-8.0.36-1 --checksum 29bdcd96f3403fb46201e17084bb4f7fd79b1a55bba63e887a9f6266c3d7b11f
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/data /app

COPY rootfs /

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 808

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
