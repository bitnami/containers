FROM gcr.io/stacksmith-images/minideb:jessie-r2
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=10.1.0-r0 \
    BITNAMI_APP_NAME=wildfly \
    BITNAMI_APP_USER=wildfly

RUN bitnami-pkg install java-1.8.0_101-0 --checksum 66b64f987634e1348141e0feac5581b14e63064ed7abbaf7ba5646e1908219f9
ENV PATH=/opt/bitnami/java/bin:$PATH

RUN bitnami-pkg unpack wildfly-10.1.0-0 --checksum ebedc7f40d0aea7bd41c8aaf87ec7946594cae9099495fe4d4e41880e0799fc1
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/data /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "wildfly"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 8080 9990
