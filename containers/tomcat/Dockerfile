FROM gcr.io/stacksmith-images/ubuntu:14.04-r9
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=8.0.35-r2 \
    BITNAMI_APP_NAME=tomcat \
    BITNAMI_APP_USER=tomcat

RUN bitnami-pkg install java-1.8.0_101-0 --checksum 66b64f987634e1348141e0feac5581b14e63064ed7abbaf7ba5646e1908219f9
ENV PATH=/opt/bitnami/java/bin:$PATH

RUN bitnami-pkg unpack tomcat-8.0.36-0 --checksum e4402f645bc95011066d60250347039cd47407a6257fb5f477d8b562facdbb17
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/data /app

ENV PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:$PATH

COPY rootfs/ /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami", "start", "--foreground", "tomcat"]

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 8080
