FROM bitnami/minideb-extras:jessie-r15
MAINTAINER Bitnami <containers@bitnami.com>

# Install required system packages and dependencies
RUN install_packages libc6 libcomerr2 libcurl3 libexpat1 libffi6 libfontconfig1 libfreetype6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libidn11 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libnettle4 libp11-kit0 libpcre3 libpng12-0 librtmp1 libsasl2-2 libselinux1 libssh2-1 libssl1.0.0 libstdc++6 libtasn1-6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27
RUN bitnami-pkg install tomcat-8.0.43-0 --checksum c645aef1669738222df7c2f9a0350467896c4a0ee49c7d67193981de9ab36f1f
RUN bitnami-pkg install git-2.10.1-2 --checksum 6f9fd8b0591f268f965930db0c091598e5c4f9dccbb6853010e1ac9e5035cd6f
RUN bitnami-pkg unpack jenkins-2.58-0 --checksum 006567c5ded1bca7e907be00c3208d2455120dd7551fabf0a07258c37684b042

COPY rootfs /

ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.58-r0" \
    JENKINS_PASSWORD="bitnami" \
    JENKINS_USERNAME="user" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:/opt/bitnami/git/bin:$PATH"

VOLUME ["/bitnami/jenkins"]

EXPOSE 8080 8443 50000

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","tomcat"]
