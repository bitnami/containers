FROM oraclelinux:7-slim
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV HOME="/" \
    OS_ARCH="x86_64" \
    OS_FLAVOUR="ol-7" \
    OS_NAME="linux"

COPY prebuildfs /
# Install required system packages and dependencies
RUN install_packages ca-certificates curl cyrus-sasl-lib glibc gzip hostname keyutils-libs krb5-libs libaio-devel libcom_err libevent libselinux nss-softokn-freebl pcre procps-ng sudo tar which
RUN . ./libcomponent.sh && component_unpack "memcached" "1.5.21-0" --checksum 84cda9bd5a02af33ab9c12f7af6b0170958c44bcbd9f964169c70c62d9aaa091
RUN yum upgrade -y && \
    rm -r /var/cache/yum
RUN /build/install-gosu.sh

COPY rootfs /
RUN /postunpack.sh
ENV BITNAMI_APP_NAME="memcached" \
    BITNAMI_IMAGE_VERSION="1.5.21-ol-7-r7" \
    PATH="/opt/bitnami/memcached/bin:$PATH"

EXPOSE 11211

USER 1001
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/run.sh" ]
