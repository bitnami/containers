FROM bitnami/oraclelinux-extras-base:7-r425
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages GeoIP glibc keyutils-libs krb5-libs libcom_err libselinux nss-softokn-freebl openssl-libs pcre zlib
RUN . ./libcomponent.sh && component_unpack "nginx" "1.16.1-1" --checksum 77740c3ba899b88ddb3c42bc36bbec88a88af741a02ea7968ae9b504bdbce961
RUN ln -sf /dev/stdout /opt/bitnami/nginx/logs/access.log
RUN ln -sf /dev/stderr /opt/bitnami/nginx/logs/error.log
RUN chmod -R g+rwX /opt/bitnami/nginx/conf

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="nginx" \
    BITNAMI_IMAGE_VERSION="1.16.1-ol-7-r46" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/nginx/sbin:$PATH"

EXPOSE 8080 8443

WORKDIR /app
USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
