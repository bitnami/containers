FROM bitnami/oraclelinux-extras:7-r474
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc zlib
RUN bitnami-pkg install java-1.8.222-1 --checksum 664cacaa11342e877410b197d21343543c2987cd66f15d2adc32cc61eee48eaa
RUN bitnami-pkg unpack tomcat-7.0.96-1 --checksum 7fea32150a6f4a4fdde7e52ca2ea4acc73f1524b43bdf39bac878225e3a9227d

COPY rootfs /
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="7.0.96-ol-7-r56" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "tomcat" ]
