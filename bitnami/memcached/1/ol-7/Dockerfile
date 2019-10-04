FROM bitnami/oraclelinux-extras-base:7-r437
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

# Install required system packages and dependencies
RUN install_packages cyrus-sasl-lib glibc keyutils-libs krb5-libs libcom_err libevent libselinux nss-softokn-freebl pcre
RUN . ./libcomponent.sh && component_unpack "memcached" "1.5.19-0" --checksum 2fb5402d20bef407358c8c1f41a92cfb79e08cea13a0e7b68350354d1171de42

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.19-ol-7-r4" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
