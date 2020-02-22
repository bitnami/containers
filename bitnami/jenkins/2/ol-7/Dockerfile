FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV PATH="/opt/bitnami/java/bin:/opt/bitnami/git/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl cyrus-sasl-lib fontconfig glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libcurl libgcc libidn libselinux libssh2 nspr nss nss-softokn-freebl nss-util openldap openssl-libs pcre procps-ng sudo tar unzip which zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install java-1.8.242-0 --checksum 974f750091ac1bf18cc1ce9472ef5ed7c1b328a2c17471cb9ac810fcded67151
RUN bitnami-pkg install git-2.25.1-0 --checksum 037457371b4782c6e780a899463a54544590a20a12c344bf5d14cef5ef470077
RUN bitnami-pkg unpack jenkins-2.204.2-2 --checksum a1d1736c694ad52c488a5299897e88f25fc72681bca3146a37adc49ca082b703
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh
RUN /build/install-tini.sh
RUN mkdir -p /usr/share/jenkins/ref

COPY rootfs /
RUN ln -sf /install-plugins.sh /usr/local/bin/install-plugins.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.204.2-ol-7-r21" \
    DISABLE_JENKINS_INITIALIZATION="no" \
    JAVA_OPTS="" \
    JENKINS_HOME="/opt/bitnami/jenkins/jenkins_home" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user"

EXPOSE 8080 8443 50000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
