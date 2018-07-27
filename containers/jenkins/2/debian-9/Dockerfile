FROM bitnami/minideb-extras:stretch-r90
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libblkid1 libbsd0 libc6 libcomerr2 libcurl3 libffi6 libgcc1 libgcrypt20 libglib2.0-0 libgmp10 libgnutls30 libgpg-error0 libgssapi-krb5-2 libhogweed4 libidn11 libidn2-0 libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libmount1 libnettle6 libnghttp2-14 libp11-kit0 libpcre3 libpsl5 librtmp1 libsasl2-2 libselinux1 libssh2-1 libssl1.0.2 libssl1.1 libstdc++6 libtasn1-6 libunistring0 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 openssh-client zlib1g
RUN bitnami-pkg install java-1.8.181-0 --checksum fe9545bdf0a75f853a01046192f7076de685dc496a1d20427608c3c68b54029b
RUN bitnami-pkg unpack tomcat-8.0.53-0 --checksum 95923a8a473e6a7b26c38331c4272fb2e4babf26de5703e5597ccad47ca07ee2
RUN bitnami-pkg install git-2.18.0-0 --checksum eb30adad4ac36d485532b4a8a99871c3824722d09707e73328f0ac1190ab24d6
RUN bitnami-pkg unpack jenkins-2.121.2-1 --checksum 1873aedf97c2c7451d9c3942f8a10937dd4d6ddf05256d7f6882fe54e7194c7d

COPY rootfs /
ENV BITNAMI_APP_NAME="jenkins" \
    BITNAMI_IMAGE_VERSION="2.121.2-debian-9-r10" \
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
