FROM gcr.io/stacksmith-images/ubuntu:14.04-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_VERSION=10.0.0-r1 \
    BITNAMI_APP_NAME=wildfly \
    BITNAMI_APP_USER=wildfly

RUN bitnami-pkg install java-1.8.0_101-0 --checksum 66b64f987634e1348141e0feac5581b14e63064ed7abbaf7ba5646e1908219f9
ENV PATH=/opt/bitnami/java/bin:$PATH

RUN bitnami-pkg unpack wildfly-10.0.0-0 --checksum 3d8d661ddef01ade02a7d2d9a4ca70915be242fccbcf2295f0b484dc0630dd4c
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/data /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "wildfly"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 8080 9990
