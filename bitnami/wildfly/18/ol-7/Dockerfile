FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/home/wildfly" \
    HOME="/" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:/opt/bitnami/nami/bin:$PATH"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl glibc gzip hostname libaio libaio-devel libgcc procps-ng sudo tar which zlib
RUN /build/bitnami-user.sh && \
    /build/install-nami.sh
RUN bitnami-pkg install java-1.8.232-0 --checksum fbac74363c807fce14538c5f9a9232602adc7883c1c5936571c741625de2479e
RUN bitnami-pkg unpack wildfly-18.0.1-2 --checksum 8140612d5885e56bd44a7966a8439521bb2dc436bb6282b4e5e3bcc3693c3174
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN ln -sf /opt/bitnami/wildfly/data /app
RUN /build/install-gosu.sh
RUN /build/install-tini.sh

COPY rootfs /
ENV BITNAMI_APP_NAME="wildfly" \
    BITNAMI_IMAGE_VERSION="18.0.1-ol-7-r70" \
    NAMI_PREFIX="/.nami" \
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
