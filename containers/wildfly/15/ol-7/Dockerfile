FROM bitnami/oraclelinux-extras:7-r200
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/home/wildfly" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libaio libblkid libffi libgcc libmount libselinux libuuid pcre zlib
RUN bitnami-pkg install java-1.8.191-20 --checksum 385a62502dbd62180858f6d4f6afde334dad9862e0caab022c2327b467d1283d
RUN bitnami-pkg unpack wildfly-15.0.0-0 --checksum d5008164c23e3bcca8fccdc01ce448a45b3d0b9fd64398ebde2094b974b41e19
RUN ln -sf /opt/bitnami/wildfly/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="wildfly" \
    BITNAMI_IMAGE_VERSION="15.0.0-ol-7-r7" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:$PATH" \
    WILDFLY_HOME="/home/wildfly" \
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

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "/run.sh" ]
