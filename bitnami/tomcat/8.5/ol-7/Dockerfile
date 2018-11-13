FROM bitnami/oraclelinux-extras:7-r167
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libuuid pcre zlib
RUN bitnami-pkg install java-1.8.191-3 --checksum 47989825b516e8a1ea9f4a8a78e7e4f0a5a8d09515bd75d6fd75f2dd5c00fe3d
RUN bitnami-pkg unpack tomcat-8.5.35-0 --checksum 1620211ba18ae8b654ad20f8145220a2cb5401a6dc7a79fb6c13451548ae2b09
RUN ln -sf /opt/bitnami/tomcat/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="8.5.35-ol-7-r5" \
    JAVA_OPTS="-Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH" \
    TOMCAT_AJP_PORT_NUMBER="8009" \
    TOMCAT_ALLOW_REMOTE_MANAGEMENT="0" \
    TOMCAT_HTTP_PORT_NUMBER="8080" \
    TOMCAT_PASSWORD="" \
    TOMCAT_SHUTDOWN_PORT_NUMBER="8005" \
    TOMCAT_USERNAME="user"

EXPOSE 8080

ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "tomcat" ]
