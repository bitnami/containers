FROM bitnami/oraclelinux-extras:7-r155
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glib2 glibc keyutils-libs krb5-libs libblkid libcom_err libcurl libffi libgcc libidn libmount libselinux libssh2 libuuid nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre unzip zlib
RUN bitnami-pkg install java-1.8.191-1 --checksum 3997bf3325da463f2392c36882a1d56e52b5a52ce7124b7895755b4e95454032
RUN bitnami-pkg install git-2.19.1-2 --checksum f216b1ac61b0bf86f3531671dee5be53c42ea436789484961bb41148911b32fa
RUN bitnami-pkg unpack jenkins-2.138.2-2 --checksum 88a25b738ddbcbd37fd8ef941f1e0f3d5f678d26649dce42e297d9c5d27a7e27
RUN mkdir -p /usr/share/jenkins/ref

COPY rootfs /
RUN ln -sf /install-plugins.sh /usr/local/bin/install-plugins.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.138.2-ol-7-r22" \
    DISABLE_JENKINS_INITIALIZATION="no" \
    JAVA_OPTS="" \
    JENKINS_HOME="/opt/bitnami/jenkins/jenkins_home" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 8080 8443 50000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "jenkins" ]
