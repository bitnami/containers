FROM bitnami/minideb-extras:jessie-r23
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libffi6 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle4 libp11-kit0 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libtasn1-6 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.161-0 --checksum eb289afc43eda33d5920294460dc256f6543318506ca5a540bba9073412cfd06
RUN bitnami-pkg unpack tomcat-8.0.48-0 --checksum 42db3fa224a92161481e307cdd56d03dd92b691e59972936dc7decacedfcbcf8
RUN bitnami-pkg install git-2.16.0-0 --checksum 70ecd7552d3b238d5644f13c06f9cb73a44457e30a60622b4638c124e1753365
RUN bitnami-pkg unpack jenkins-2.103.0-0 --checksum bc53575e02aab6b3520296ac62d5881d82b617d7bc5cf0afa012c7850ef4b8cf

COPY rootfs /

ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.103.0-r0" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/git/bin:$PATH" \
    TOMCAT_AJP_PORT_NUMBER="8009" \
    TOMCAT_ALLOW_REMOTE_MANAGEMENT="0" \
    TOMCAT_HTTP_PORT_NUMBER="8080" \
    TOMCAT_PASSWORD="" \
    TOMCAT_SHUTDOWN_PORT_NUMBER="8005" \
    TOMCAT_USERNAME="user"

EXPOSE 8080 8443 50000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","tomcat"]
