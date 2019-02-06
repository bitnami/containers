FROM bitnami/oraclelinux-extras:7-r252
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib fontconfig glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre unzip zlib
RUN bitnami-pkg install java-1.8.201-0 --checksum e71b797ceaaf8b0641d1641df129cea10124b058bc24d4ed74738725fabfb8c9
RUN bitnami-pkg install git-2.20.1-20 --checksum 160b41e17f0414c1206e97cc1eef3720596c0229922b68d4ded4a69bfc08cc51
RUN bitnami-pkg unpack jenkins-2.150.2-1 --checksum d4dd0a5de0294b872ead2da3d213bea80a599dd9583f4c3b2400564b365bf93e
RUN mkdir -p /usr/share/jenkins/ref

COPY rootfs /
RUN ln -sf /install-plugins.sh /usr/local/bin/install-plugins.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.150.2-ol-7-r18" \
    DISABLE_JENKINS_INITIALIZATION="no" \
    JAVA_OPTS="" \
    JENKINS_HOME="/opt/bitnami/jenkins/jenkins_home" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 8080 8443 50000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
