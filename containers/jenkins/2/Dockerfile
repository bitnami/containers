FROM bitnami/minideb-extras:jessie-r30
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libffi6 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle4 libp11-kit0 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libtasn1-6 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.171-0 --checksum c5ea6aa978992a3606b070b3ef4287b0b8118611f015281868f4466a81c299b1
RUN bitnami-pkg unpack tomcat-8.0.51-0 --checksum 53d4e40acbdaf7637f9fdb31fa013ec7397ff2a892fcf51bc0f7224f5ac530a3
RUN bitnami-pkg install git-2.17.0-0 --checksum fbfa53f51d88bf6a8f0222f8861ed3b91f8ba4a0f7e1d8e132c3c5a596c963b2
RUN bitnami-pkg unpack jenkins-2.107.2-0 --checksum 5462ed17cfeb23979d380fa767bffe269e36005f468f1bd59b5ce09632b989d0

COPY rootfs /
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.107.2-r3" \
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
