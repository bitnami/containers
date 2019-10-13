FROM bitnami/oraclelinux-extras:7-r495
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/home/wildfly" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libaio libgcc zlib
RUN bitnami-pkg install java-1.8.222-1 --checksum 664cacaa11342e877410b197d21343543c2987cd66f15d2adc32cc61eee48eaa
RUN bitnami-pkg unpack wildfly-18.0.0-0 --checksum 4e0257a0ae4897c8c83cfc22835ee70ed731a1f5e1fc4855cfdd5a5db7ff4591
RUN ln -sf /opt/bitnami/wildfly/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="wildfly" \
    BITNAMI_IMAGE_VERSION="18.0.0-ol-7-r4" \
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
