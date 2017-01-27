FROM gcr.io/stacksmith-images/minideb:jessie-r8

MAINTAINER Bitnami <containers@bitnami.com>

ENV BITNAMI_IMAGE_VERSION=9.0.0.M17-r1 \
    BITNAMI_APP_NAME=tomcat \
    BITNAMI_APP_USER=tomcat \
    PATH=/opt/bitnami/$BITNAMI_APP_NAME/bin:/opt/bitnami/java/bin:$PATH

# System packages required
RUN install_packages libc6 libxext6 libx11-6 libxcb1 libxau6 libxdmcp6 libglib2.0-0 libfreetype6 libfontconfig1 libstdc++6 libgcc1 zlib1g libselinux1 libpng12-0 libexpat1 libffi6 libpcre3 libxml2 liblzma5

# Additional modules required
RUN bitnami-pkg install java-1.8.0_121-0 --checksum 2743f753fd1ea88bf90352d95694f89ab0a0fb855cf0d1c7b2a6d92835f9ad27

# Install tomcat
RUN bitnami-pkg unpack tomcat-9.0.0.M17-1 --checksum faf6d4bd2a9ffb3db8f27befe4902bd8baa7aa3872fb3a249d91a108dbec00e1
RUN ln -sf /opt/bitnami/$BITNAMI_APP_NAME/data /app

COPY rootfs /

VOLUME ["/bitnami/$BITNAMI_APP_NAME"]

EXPOSE 8080

ENTRYPOINT ["/app-entrypoint.sh"]

CMD ["nami", "start", "--foreground", "tomcat"]
