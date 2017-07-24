FROM bitnami/minideb-extras:jessie-r19
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libnettle4 libp11-kit0 libpcre3 librtmp1 libsasl2-2 libselinux1 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.141-0 --checksum 5e3e833f2899154285a7feb3d1511f26493f6091774ea90698c71866629991ff
RUN bitnami-pkg unpack tomcat-8.0.45-0 --checksum 60daf4854d9db0cb2bbe65510b25a6f861f59374eeaef27d8e7b8ce3faa76b01
RUN bitnami-pkg install git-2.14.0-rc0-0 --checksum 9a880f27ee8a6eafbc8f30fc14386b3f51622bf058b7335506e45caa1b8c44f2
RUN bitnami-pkg unpack jenkins-2.71.0-0 --checksum 1b2bd7c58823b6dc868953c9bf034f7c5b95c0e4ae3c37e8826e5df2a083417c

COPY rootfs /

ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.71.0-r0" \
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
