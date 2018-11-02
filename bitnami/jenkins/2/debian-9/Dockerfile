FROM bitnami/minideb-extras:stretch-r185
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libblkid1 libbsd0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libmount1 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpsl5 librtmp1 libsasl2-2 libselinux1 libssh2-1 libssl1.0.2 libssl1.1 libtasn1-6 libunistring0 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 unzip zlib1g
RUN bitnami-pkg install java-1.8.191-1 --checksum f05ed830d741b7dbdb3d09066552239023730516bdd2fd64578b66decd0ff867
RUN bitnami-pkg install git-2.19.1-2 --checksum afed897918bbbf73d72e4cb9b72e30dc43b09ed322d390e0cee889ee75c2e080
RUN bitnami-pkg unpack jenkins-2.138.2-2 --checksum 00e07eb3487e1d8444198204bf9c41f43e9751c53bbd84641874d31fd0e6f94e
RUN mkdir -p /usr/share/jenkins/ref

COPY rootfs /
RUN ln -sf /install-plugins.sh /usr/local/bin/install-plugins.sh
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.138.2-debian-9-r21" \
    DISABLE_JENKINS_INITIALIZATION="no" \
    JAVA_OPTS="" \
    JENKINS_HOME="/opt/bitnami/jenkins/jenkins_home" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/git/bin:$PATH"

EXPOSE 8080 8443 50000

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "jenkins" ]
