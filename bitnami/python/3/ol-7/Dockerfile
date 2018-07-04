FROM bitnami/oraclelinux-extras:7-r25
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages build-essential bzip2-libs ca-certificates curl git glibc keyutils-libs krb5-libs libcom_err libselinux ncurses-libs nss-softokn-freebl openssl-libs pcre pkg-config readline sqlite unzip wget xz-libs zlib
RUN bitnami-pkg install python-3.6.5-0 --checksum 2bd4a70747cbfb99c89f4d679b4474410612cb81bd9f2cec126f846b0fcf4749

COPY rootfs /
ENV BITNAMI_APP_NAME="python" \
    BITNAMI_IMAGE_VERSION="3.6.5-ol-7-r11" \
    PATH="/opt/bitnami/python/bin:$PATH"

EXPOSE 8000

WORKDIR /app
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["python"]
