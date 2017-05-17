FROM bitnami/minideb-extras:jessie-r15
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages libc6 libexpat1 libffi6 libfontconfig1 libfreetype6 libgcc1 libglib2.0-0 liblzma5 libpcre3 libpng12-0 libselinux1 libstdc++6 libx11-6 libxau6 libxcb1 libxdmcp6 libxext6 libxml2 zlib1g
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27
RUN bitnami-pkg unpack wildfly-11.0.0-0 --checksum 210294a19deaba0d3614123086f54b538e4a51fb633498f0ed61226b4048e63f
RUN ln -sf /opt/bitnami/wildfly/data /app

COPY rootfs /

ENV BITNAMI_APP_NAME="wildfly" \
    BITNAMI_IMAGE_VERSION="11.0.0-r2" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/wildfly/bin:$PATH" \
    WILDFLY_JAVA_HOME="" \
    WILDFLY_JAVA_OPTS="" \
    WILDFLY_MANAGEMENT_HTTP_PORT="9990" \
    WILDFLY_PASSWORD="bitnami" \
    WILDFLY_PUBLIC_CONSOLE="true" \
    WILDFLY_SERVER_AJP_PORT="8009" \
    WILDFLY_SERVER_HTTP_PORT="8080" \
    WILDFLY_SERVER_INTERFACE="0.0.0.0" \
    WILDFLY_USERNAME="user" \
    WILDFLY_WILDFLY_HOME="/home/wildfly" \
    WILDFLY_WILDFLY_OPTS="-Dwildfly.as.deployment.ondemand=false"

VOLUME ["/bitnami/wildfly"]

EXPOSE 8080 9990

ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["nami","start","--foreground","wildfly"]
