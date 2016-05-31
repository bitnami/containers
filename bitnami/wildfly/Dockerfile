FROM gcr.io/stacksmith-images/ubuntu:14.04-r07
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_VERSION=10.0.0-r0 \
    BITNAMI_APP_NAME=wildfly \
    BITNAMI_APP_USER=wildfly

RUN bitnami-pkg install java-1.8.0_91-0 --checksum 64cf20b77dc7cce3a28e9fe1daa149785c9c8c13ad1249071bc778fa40ae8773
ENV PATH=/opt/bitnami/java/bin:$PATH

RUN bitnami-pkg unpack wildfly-10.0.0-0 --checksum 3d8d661ddef01ade02a7d2d9a4ca70915be242fccbcf2295f0b484dc0630dd4c
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/data /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["harpoon", "start", "--foreground", "wildfly"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 8080 9990
