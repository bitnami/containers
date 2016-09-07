FROM gcr.io/stacksmith-images/ubuntu:14.04-r9

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=jasperserver \
    BITNAMI_APP_VERSION=6.3.0 \
    PATH=/opt/bitnami/tomcat/bin:/opt/bitnami/mysql/bin/:$PATH

# Additional modules required
RUN bitnami-pkg install java-1.8.0_101-0 --checksum 66b64f987634e1348141e0feac5581b14e63064ed7abbaf7ba5646e1908219f9
RUN bitnami-pkg install tomcat-8.0.36-0 --checksum e4402f645bc95011066d60250347039cd47407a6257fb5f477d8b562facdbb17
RUN bitnami-pkg install mysql-client-10.1.13-4 --checksum 14b45c91dd78b37f0f2366712cbe9bfdf2cb674769435611955191a65dbf4976

# Install jasperserver
RUN bitnami-pkg unpack jasperserver-6.3.0-0 --checksum c6681be456d6a13305c258f16effd7a4ef4ae0d1212aada3bf18c08b2c7e929c

COPY rootfs /

VOLUME ["/bitnami/jasperserver"]

EXPOSE 8080 8443

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
