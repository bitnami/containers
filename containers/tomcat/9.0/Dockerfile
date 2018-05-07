FROM bitnami/minideb-extras:jessie-r40
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN bitnami-pkg install java-1.8.171-0 --checksum c5ea6aa978992a3606b070b3ef4287b0b8118611f015281868f4466a81c299b1
RUN bitnami-pkg unpack tomcat-9.0.8-0 --checksum 7a246559ae5b39ccd6da5467e740f7827d77f8200e7f277e01810a42fc704dba
RUN ln -sf /opt/bitnami/tomcat/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="9.0.8-r3" \
    JAVA_OPTS="-Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH" \
    TOMCAT_AJP_PORT_NUMBER="8009" \
    TOMCAT_ALLOW_REMOTE_MANAGEMENT="0" \
    TOMCAT_HTTP_PORT_NUMBER="8080" \
    TOMCAT_PASSWORD="" \
    TOMCAT_SHUTDOWN_PORT_NUMBER="8005" \
    TOMCAT_USERNAME="user"

EXPOSE 8080

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","tomcat"]
