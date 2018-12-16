FROM bitnami/oraclelinux-extras:7-r199
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    BITNAMI_PKG_EXTRA_DIRS="/home/tomcat" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glib2 glibc libblkid libffi libgcc libmount libselinux libuuid pcre zlib
RUN bitnami-pkg install java-1.8.191-20 --checksum 385a62502dbd62180858f6d4f6afde334dad9862e0caab022c2327b467d1283d
RUN bitnami-pkg unpack tomcat-9.0.14-0 --checksum 81b61cbdf148fb1fc12043c8171f43b5dc9166a4004107d0705670ea4c443add
RUN ln -sf /opt/bitnami/tomcat/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="9.0.14-ol-7-r12" \
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
