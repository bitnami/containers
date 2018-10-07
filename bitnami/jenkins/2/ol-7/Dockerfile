FROM bitnami/oraclelinux-extras:7-r129
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glib2 glibc keyutils-libs krb5-libs libblkid libcom_err libcurl libffi libgcc libidn libmount libselinux libssh2 libstdc++ libuuid nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre unzip zlib
RUN bitnami-pkg install java-1.8.181-1 --checksum 6e7fc2779b6e0e3c6c0a2687b1d747d8a427594ff80b8c94b055c839e387e6b1
RUN bitnami-pkg install git-2.19.1-0 --checksum a50a849103d0908bb94c4a048622aae0b090af99739309f7f2a093e119e9453e
RUN bitnami-pkg unpack jenkins-2.138.1-3 --checksum ac1f4b1f6cac9974253c332f9c7d9c26b7a0835343aa991baa7131052f4134c6
RUN mkdir -p /usr/share/jenkins/ref

COPY rootfs /
RUN ln -sf /install-plugins.sh /usr/local/bin/install-plugins.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.138.1-ol-7-r27" \
    DISABLE_JENKINS_INITIALIZATION="no" \
    JAVA_OPTS="" \
    JENKINS_HOME="/opt/bitnami/jenkins/jenkins_home" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 8080 8443 50000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "jenkins" ]
