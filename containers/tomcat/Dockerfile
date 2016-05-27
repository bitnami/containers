FROM gcr.io/stacksmith-images/ubuntu:14.04-r07
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=8.0.35-r0 \
    BITNAMI_APP_NAME=tomcat \
    BITNAMI_APP_USER=tomcat

RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773
ENV PATH=/opt/bitnami/java/bin:$PATH

RUN bitnami-pkg unpack tomcat-8.0.35-0 --checksum d86af6bade1325215d4dd1b63aefbd4a57abb05a71672e5f58e27ff2fd49325b
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/data /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "tomcat"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 8080
