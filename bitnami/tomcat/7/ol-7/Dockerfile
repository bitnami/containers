FROM bitnami/oraclelinux-extras:7-r252
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/home/tomcat" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc
RUN bitnami-pkg install java-1.8.201-0 --checksum e71b797ceaaf8b0641d1641df129cea10124b058bc24d4ed74738725fabfb8c9
RUN bitnami-pkg unpack tomcat-7.0.92-21 --checksum 511f71f1c18a0c09b62c39a35844b0ffc51eef9777200ccc8fb2b1a722216512
RUN ln -sf /opt/bitnami/tomcat/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="7.0.92-ol-7-r78" \
    JAVA_OPTS="-Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH" \
    TOMCAT_AJP_PORT_NUMBER="8009" \
    TOMCAT_ALLOW_REMOTE_MANAGEMENT="0" \
    TOMCAT_HOME="/home/tomcat" \
    TOMCAT_HTTP_PORT_NUMBER="8080" \
    TOMCAT_PASSWORD="" \
    TOMCAT_SHUTDOWN_PORT_NUMBER="8005" \
    TOMCAT_USERNAME="user"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "tomcat" ]
