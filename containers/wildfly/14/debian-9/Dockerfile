FROM bitnami/minideb-extras:stretch-r188
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libaio1 libblkid1 libbsd0 libc6 libffi6 libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libuuid1 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 zlib1g
RUN bitnami-pkg install java-1.8.191-1 --checksum f05ed830d741b7dbdb3d09066552239023730516bdd2fd64578b66decd0ff867
RUN bitnami-pkg unpack wildfly-14.0.1-2 --checksum bec82b4087fa1411dba777e1c5de0ea0e198a2b3a0a0e06f28617ee6ce88bca7
RUN ln -sf /opt/bitnami/wildfly/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="wildfly" \
    BITNAMI_IMAGE_VERSION="14.0.1-debian-9-r48" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:$PATH" \
    WILDFLY_JAVA_HOME="" \
    WILDFLY_JAVA_OPTS="" \
    WILDFLY_MANAGEMENT_HTTP_PORT_NUMBER="9990" \
    WILDFLY_PASSWORD="bitnami" \
    WILDFLY_PUBLIC_CONSOLE="true" \
    WILDFLY_SERVER_AJP_PORT_NUMBER="8009" \
    WILDFLY_SERVER_HTTP_PORT_NUMBER="8080" \
    WILDFLY_SERVER_INTERFACE="0.0.0.0" \
    WILDFLY_USERNAME="user" \
    WILDFLY_WILDFLY_HOME="/home/wildfly" \
    WILDFLY_WILDFLY_OPTS="-Dwildfly.as.deployment.ondemand=false"

EXPOSE 8080 9990

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "wildfly" ]
