FROM bitnami/oraclelinux-extras:7-r203
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/home/tomcat" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libuuid pcre zlib
RUN bitnami-pkg install java-1.8.191-20 --checksum 385a62502dbd62180858f6d4f6afde334dad9862e0caab022c2327b467d1283d
RUN bitnami-pkg unpack tomcat-8.5.37-0 --checksum 5731bdb01d0cb9c23e22a7aa768433be81c39dbaf2da2849242908dd8a2c1564
RUN ln -sf /opt/bitnami/tomcat/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="8.5.37-ol-7-r1" \
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
