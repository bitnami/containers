FROM bitnami/oraclelinux-extras:7-r535
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib fontconfig glibc keyutils-libs krb5-libs libcom_err libcurl libgcc libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre unzip zlib
RUN bitnami-pkg install java-1.8.232-0 --checksum fbac74363c807fce14538c5f9a9232602adc7883c1c5936571c741625de2479e
RUN bitnami-pkg install git-2.24.0-0 --checksum a05099de6d8c26088d81b69c3519e45e481d4605beffaa509eb5b6e6dfed0d90
RUN bitnami-pkg unpack jenkins-2.190.2-1 --checksum 804a5445f923d6c81a1d2a3e3455b85d32d1039f639ea09465cc07c3df457ab1
RUN mkdir -p /usr/share/jenkins/ref

COPY rootfs /
RUN ln -sf /install-plugins.sh /usr/local/bin/install-plugins.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.190.2-ol-7-r24" \
    DISABLE_JENKINS_INITIALIZATION="no" \
    JAVA_OPTS="" \
    JENKINS_HOME="/opt/bitnami/jenkins/jenkins_home" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 8080 8443 50000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
