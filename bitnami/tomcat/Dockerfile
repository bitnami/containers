FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=8.0.39-r1 \
    BITNAMI_APP_NAME=tomcat \
    BITNAMI_APP_USER=tomcat \
    PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/java/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_111-0 --checksum a40aa0c9553e13bd8ddcc3d2ba966492b79d4f73d47cb1499c9ec54f441201eb

# Install tomcat
RUN bitnami-pkg unpack tomcat-8.0.39-1 --checksum 85d159a4e0458c08fbbb44ce821b4367bc122ea6a27c9f5ba22cc4ef0ecbb15b
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/data /app

COPY rootfs /

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 8080

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
