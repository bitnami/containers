FROM bitnami/minideb-extras:jessie-r22
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libnettle4 libp11-kit0 libpcre3 librtmp1 libsasl2-2 libselinux1 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.144-0 --checksum 8b4315727f65780d8223df0aeaf5e3beca10a14aa4e2cdd1f3541ab50b346433
RUN bitnami-pkg unpack tomcat-8.0.46-0 --checksum 02056d0a91b8888982b9f8ef68c5957090cf2c3953f2d6417628505d54f8bf49
RUN bitnami-pkg install git-2.14.1-0 --checksum 6c7935c7f028ab8e8ea38ffab8269b57d87b69b31aae0fc3af8a496e76d0e9cc
RUN bitnami-pkg unpack jenkins-2.79.0-0 --checksum e831042f5942f39f63e066f8f7dcb1669b5569e37c56eb54729515161b5c10ac

COPY rootfs /

ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.79.0-r0" \
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
