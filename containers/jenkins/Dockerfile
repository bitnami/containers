FROM gcr.io/stacksmith-images/ubuntu:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=jenkins \
    BITNAMI_IMAGE_VERSION=2.21-r1 \
    PATH=/opt/bitnami/tomcat/bin:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_101-0 --checksum 66b64f987634e1348141e0feac5581b14e63064ed7abbaf7ba5646e1908219f9
RUN bitnami-pkg install tomcat-8.5.4-0 --checksum d2033af8a2d0d80a027fd8d2142a3ac20568615b34daa2a3cd1d944ba9c106c3

# Install jenkins
RUN bitnami-pkg unpack jenkins-2.21-0 --checksum 1ae9b7ceba18b15396752ff58b954c0511e5e6d502369bb906844742e6d977f4

COPY rootfs /

VOLUME ["/bitnami/jenkins"]

EXPOSE 8080 8443 50000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
