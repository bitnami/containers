FROM bitnami/minideb-extras:jessie-r15
MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=11.0.0-r1 \
    BITNAMI_APP_NAME=wildfly \
    PATH=/opt/bitnami/wildfly/bin:/opt/bitnami/java/bin:$PATH

# System packages required
RUN install_packages libc6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 zlib1g libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5

# Additional modules required
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27

# Install wildfly
RUN bitnami-pkg unpack wildfly-11.0.0-0 --checksum 210294a19deaba0d3614123086f54b538e4a51fb633498f0ed61226b4048e63f
RUN ln -sf /opt/bitnami/wildfly/data /app

COPY rootfs/ /

ENV WILDFLY_USERNAME=user \
    WILDFLY_PASSWORD=bitnami

VOLUME ["/bitnami/wildfly"]

EXPOSE 8080 9990

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "wildfly"]
