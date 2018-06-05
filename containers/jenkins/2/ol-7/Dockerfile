FROM bitnami/oraclelinux-extras:7-r5
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glib2 glibc keyutils-libs krb5-libs libblkid libcom_err libcurl libffi libgcc libidn libmount libselinux libssh2 libstdc++ libuuid nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre zlib
RUN bitnami-pkg install java-1.8.171-3 --checksum eb0af616b0a3ab12bd8559a36e83246eb10e7893f6a654dc14a462246d433e40
RUN bitnami-pkg unpack tomcat-8.0.52-2 --checksum d54687bce7731651a2bc51dbcbf0484c3dde7c5ff4f8376326775c005373b781
RUN bitnami-pkg install git-2.17.1-0 --checksum 34af999e4caa742b80a8e6670e24368ff7df141d59686deebad6225838ff6bc9
RUN bitnami-pkg unpack jenkins-2.107.3-3 --checksum 88ac784391e7165014cbe550758156ada0aaddf7a75f997781653d55bc88e6e1

COPY rootfs /
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.107.3-ol-7-r0" \
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
