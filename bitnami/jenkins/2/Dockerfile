FROM bitnami/minideb-extras:jessie-r61
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libffi6 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle4 libp11-kit0 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libtasn1-6 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.171-2 --checksum 43dee4edccde5428da7b62dbd8371a08cd4f92ebfa3dca104f1e3d8480610cda
RUN bitnami-pkg unpack tomcat-8.0.52-0 --checksum 4c3bed5f27061d8fc573a9a60441eac63da48fd54138c85dd0ec7dc8ab1a73d7
RUN bitnami-pkg install git-2.17.1-0 --checksum 948b00c283f89cac532ee3b2cd26b3efde12fe5425f25c6d836a96cebd35a8a7
RUN bitnami-pkg unpack jenkins-2.107.3-1 --checksum 6c57adf374a59622521370aa0722eff68e1aff393986f98c42300ef6481bf34e

COPY rootfs /
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.107.3-r14" \
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
