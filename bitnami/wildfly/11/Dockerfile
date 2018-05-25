FROM bitnami/minideb-extras:jessie-r56
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg install java-1.8.171-1 --checksum e8a1956085b60e632976f9671899919b245b6c4dfd0035292b4b47a16669d0fd
RUN bitnami-pkg unpack wildfly-11.0.0-1 --checksum bdcbbf014a52c494bc7b5aecaa0780726dc4f630a97b600a0596f7bfc951f2ee
RUN ln -sf /opt/bitnami/wildfly/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="wildfly" \
    BITNAMI_IMAGE_VERSION="11.0.0-r34" \
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

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","wildfly"]
