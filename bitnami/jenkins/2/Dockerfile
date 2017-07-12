FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libnettle4 libp11-kit0 libpcre3 librtmp1 libsasl2-2 libselinux1 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.131-0 --checksum 5b122a36c8ba44e2f9eb8cbb9b62dd87963742c46f85a04019115d2d43c69e33
RUN bitnami-pkg unpack tomcat-8.0.45-0 --checksum 60daf4854d9db0cb2bbe65510b25a6f861f59374eeaef27d8e7b8ce3faa76b01
RUN bitnami-pkg install git-2.13.2-0 --checksum 0c8267b16408cd9cb0f7b9041e30b9207dc51076735bca471574bb995556d588
RUN bitnami-pkg unpack jenkins-2.69.0-0 --checksum be1858df229007e2c79bb60d6dbe2cc1b8aa7fa3ea4a59dc86d255090c84697b

COPY rootfs /

ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.69.0-r0" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/git/bin:$PATH" \
    TOMCAT_AJP_PORT_NUMBER="8009" \
    TOMCAT_ALLOW_REMOTE_MANAGEMENT="0" \
    TOMCAT_HTTP_PORT_NUMBER="8080" \
    TOMCAT_SHUTDOWN_PORT_NUMBER="8005" \
    TOMCAT_USERNAME="user"

EXPOSE 8080 8443 50000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","tomcat"]
