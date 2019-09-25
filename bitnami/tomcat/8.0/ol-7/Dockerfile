FROM bitnami/oraclelinux-extras:7-r477
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages glibc libgcc zlib
RUN bitnami-pkg install java-1.8.222-1 --checksum 664cacaa11342e877410b197d21343543c2987cd66f15d2adc32cc61eee48eaa
RUN bitnami-pkg unpack tomcat-8.0.53-23 --checksum 472914d1aba64fc8af159cbe9a02b32ba10e458af60d1a5309d9af1d730a2cfb

COPY rootfs /
ENV BITNAMI_APP_NAME="tomcat" \
    BITNAMI_IMAGE_VERSION="8.0.53-ol-7-r424" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/java/bin:/opt/bitnami/tomcat/bin:$PATH"

EXPOSE 8080

USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "nami", "start", "--foreground", "tomcat" ]
