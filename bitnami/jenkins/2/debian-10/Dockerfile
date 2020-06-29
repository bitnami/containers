FROM docker.io/bitnami/minideb:buster
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/opt/bitnami" \
    HOME="/" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/git/bin:/opt/bitnami/common/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl fontconfig fonts-dejavu-extra gzip libc6 libcom-err2 libcurl4 libffi6 libgcc1 libgcrypt20 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libnettle6 libnghttp2-14 libp11-kit0 libpsl5 librtmp1 libsasl2-2 libssh2-1 libssl1.1 libtasn1-6 libunistring2 openssh-client procps sudo tar unzip zlib1g
RUN /build/bitnami-user.sh
RUN /build/install-nami.sh
RUN bitnami-pkg install java-1.8.252-4 --checksum 8e9a23094ea1ce6360b905552e55dacb1e27de4b99df7bc01ea83ea4c3fafa49
RUN bitnami-pkg install git-2.27.0-1 --checksum 8d31650a86d07490247771e216e064819564452a7e2c2fe69ffbffdb9c079b0a
RUN bitnami-pkg install tini-0.19.0-0 --checksum 9a8ae20be31a518f042fcec359f2cf35bfdb4e2a56f2fa8ff9ef2ecaf45da80c
RUN bitnami-pkg unpack jenkins-2.235.1-0 --checksum 0df546f70bbfcc79bd8e0874f1572bf732ca16e12522f41c58654942db574075
RUN bitnami-pkg install gosu-1.12.0-1 --checksum 51cfb1b7fd7b05b8abd1df0278c698103a9b1a4964bdacd87ca1d5c01631d59c
RUN apt-get update && apt-get upgrade -y && \
    rm -r /var/lib/apt/lists /var/cache/apt/archives
RUN mkdir -p /usr/share/jenkins/ref

COPY rootfs /
RUN ln -sf /install-plugins.sh /usr/local/bin/install-plugins.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.235.1-debian-10-r2" \
    DISABLE_JENKINS_INITIALIZATION="no" \
    JAVA_OPTS="" \
    JENKINS_HOME="/opt/bitnami/jenkins/jenkins_home" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user" \
    LD_PRELOAD="/opt/bitnami/common/lib/libnss_wrapper.so" \
    LNAME="jenkins" \
    NAMI_PREFIX="/.nami" \
    NSS_WRAPPER_GROUP="/opt/bitnami/jenkins/nss_group" \
    NSS_WRAPPER_PASSWD="/opt/bitnami/jenkins/nss_passwd" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux"

EXPOSE 8080 8443 50000

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
