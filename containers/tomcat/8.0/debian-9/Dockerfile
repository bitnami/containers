FROM bitnami/minideb-extras:stretch-r191
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libblkid1 libc6 libffi6 libgcc1 libglib2.0-0 libmount1 libpcre3 libselinux1 libuuid1 zlib1g
RUN bitnami-pkg install java-1.8.191-3 --checksum 7d4e5b3392c96451eb5aa9b834713f9ca37580316bc9607bd6da26ec98e7e226
RUN bitnami-pkg unpack tomcat-8.0.53-2 --checksum 5a934168aaf2afcc3fdb69bb8aafe779ef6cc38f484e7df392a6513db8d7f695
RUN ln -sf /opt/bitnami/tomcat/data /app

COPY rootfs /
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="8.0.53-debian-9-r106" \
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
