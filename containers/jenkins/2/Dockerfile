FROM bitnami/minideb-extras:jessie-r23
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libffi6 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle4 libp11-kit0 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libtasn1-6 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.161-0 --checksum eb289afc43eda33d5920294460dc256f6543318506ca5a540bba9073412cfd06
RUN bitnami-pkg unpack tomcat-8.0.50-0 --checksum c574422753a1c502e99baf0b1a650a6607214d7b9f21838a019b880b19f36276
RUN bitnami-pkg install git-2.16.1-0 --checksum 56a9643b80831a3a85e6b4cf3d5ec5399438e5e27d84089aa383f9d34ee00996
RUN bitnami-pkg unpack jenkins-2.107.0-0 --checksum e8d60d4c28b88131c082bd2af8a0fca9baecf8407b980ea6f6aad4e51bc57f5f

COPY rootfs /

ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.107.0-r0" \
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
