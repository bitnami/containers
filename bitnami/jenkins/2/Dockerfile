FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libffi6 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle4 libp11-kit0 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libtasn1-6 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.151-0 --checksum fbbea572d89988035aee16eefe53c852e8abfda84f6c7cf5c9a4772a72863143
RUN bitnami-pkg unpack tomcat-8.0.48-0 --checksum 42db3fa224a92161481e307cdd56d03dd92b691e59972936dc7decacedfcbcf8
RUN bitnami-pkg install git-2.15.1-0 --checksum 09e673452fa9f0675df177eef93feeeb8b0214c577fedfbc7e021fa550d058b0
RUN bitnami-pkg unpack jenkins-2.99.0-0 --checksum 3c3bbd143ae607bb122c2f28acea289cf3667cf52cfff979aa8322c449bacf3a

COPY rootfs /

ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.99.0-r0" \
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
