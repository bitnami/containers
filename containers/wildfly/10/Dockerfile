FROM bitnami/minideb-extras:jessie-r13
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=10.1.0-r7 \
    BITNAMI_APP_NAME=wildfly \
    PATH=/opt/bitnami/wildfly/bin:/opt/bitnami/java/bin:$PATH

# System packages required
RUN install_packages libc6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 zlib1g libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5

# Additional modules required
RUN bitnami-pkg install java-1.8.0_111-1 --checksum f7705a3955f006eb59a6e4240a01d8273b17ba38428d30ffe7d10c9cc525d7be

# Install wildfly
RUN bitnami-pkg unpack wildfly-10.1.0-1 --checksum dc2f3143f6704cc1b9e285b4475f0aea1adf89ce819e8231702235dba2a7f9ba
RUN ln -sf /opt/bitnami/wildfly/data /app

COPY rootfs/ /

ENV WILDFLY_USERNAME=user \
    WILDFLY_PASSWORD=bitnami

VOLUME ["/bitnami/wildfly"]

EXPOSE 8080 9990

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "wildfly"]
