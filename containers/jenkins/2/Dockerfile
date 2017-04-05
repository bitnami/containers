FROM bitnami/minideb-extras:jessie-r13

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_APP_NAME=jenkins \
    BITNAMI_IMAGE_VERSION=2.53-r0 \
    PATH=/opt/bitnami/tomcat/bin:/opt/bitnami/git/bin:/opt/bitnami/java/bin:$PATH

# System packages required
RUN install_packages libc6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 zlib1g libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5 libssl1.0.0 libcurl3 libidn11 librtmp1 libssh2-1 libgssapi-krb5-2 libkrb5-3 libk5crypto3 libcomerr2 libldap-2.4-2 libgnutls-deb0-28 libhogweed2 libnettle4 libgmp10 libgcrypt20 libkrb5support0 libkeyutils1 libsasl2-2 libp11-kit0 libtasn1-6 libgpg-error0 openssh-client

# Additional modules required
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27
RUN bitnami-pkg install tomcat-8.0.42-0 --checksum da6869296de3f34cd7d332062d748dd9ae040d89f993b9226d8bdfa335626913
RUN bitnami-pkg install git-2.10.1-2 --checksum 6f9fd8b0591f268f965930db0c091598e5c4f9dccbb6853010e1ac9e5035cd6f

# Install jenkins
RUN bitnami-pkg unpack jenkins-2.53-0 --checksum 19ec64ccf2dd228a0f4d999c9060299c6c188f3eb74629a439d7621fa594bda1

COPY rootfs /

ENV JENKINS_USERNAME="user" \
    JENKINS_PASSWORD="bitnami"

VOLUME ["/bitnami/jenkins"]

EXPOSE 8080 8443 50000

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
