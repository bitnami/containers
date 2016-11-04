FROM gcr.io/stacksmith-images/minideb:jessie-r2

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=jenkins \
    BITNAMI_IMAGE_VERSION=2.28-r0 \
    PATH=/opt/bitnami/tomcat/bin:/opt/bitnami/git/bin:/opt/bitnami/java/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_111-0 --checksum a40aa0c9553e13bd8ddcc3d2ba966492b79d4f73d47cb1499c9ec54f441201eb
RUN bitnami-pkg install tomcat-8.5.6-1 --checksum 74006991ca72f4097b18c6ca905ac5f4b20cb667d2358f64bb49e0b04c85e413
RUN bitnami-pkg install git-2.6.1-2 --checksum edc04dc263211f3ffdc953cb96e5e3e76293dbf7a97a075b0a6f04e048b773dd

# Install jenkins
RUN bitnami-pkg unpack jenkins-2.28-0 --checksum 46b2316f3d562f63d489883fac5bf6fa81460622c8a1af703939000c93c70b39

COPY rootfs /

VOLUME ["/bitnami/jenkins"]

EXPOSE 8080 8443 50000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
